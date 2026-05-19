import express, { Request, Response, NextFunction } from 'express'
import path from 'path'
import { createServer as createViteServer } from 'vite'
import Database from 'better-sqlite3'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

async function startServer() {
  const app = express()
  const PORT = 3000

  // Database setup
  const db = new Database('database.sqlite')
  db.exec(`
    CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      price DECIMAL(10, 2) NOT NULL,
      category_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories (id)
    );

    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  `)

  // Simple Seeder
  const categoryCount = db.prepare('SELECT COUNT(*) as count FROM categories').get() as any
  if (categoryCount.count === 0) {
    const insertCategory = db.prepare('INSERT INTO categories (name, description) VALUES (?, ?)')
    insertCategory.run('Роутеры', 'Сетевое оборудование')
    insertCategory.run('Коммутаторы', 'Оборудование для локальных сетей')
    insertCategory.run('Оптика', 'Оптоволоконное оборудование')

    const insertUser = db.prepare('INSERT INTO users (name, email, password) VALUES (?, ?, ?)')
    insertUser.run('Admin', 'admin@bth.com', 'password') // In real app, hash this
  }

  app.use(express.json())

  // Inertia middleware helper
  const inertia = (req: Request, res: Response, next: NextFunction) => {
    res.inertia = (component: string, props: any = {}) => {
      const page = {
        component,
        props: {
          ...props,
          errors: {},
          auth: {
            user: (req as any).user || null,
          },
        },
        url: req.originalUrl,
        version: '1.0.0',
      }

      if (req.header('X-Inertia')) {
        res.setHeader('X-Inertia', 'true')
        res.setHeader('Vary', 'Accept')
        return res.json(page)
      }

      // Root view rendering (will be handled by Vite in dev or static in prod)
      // For simplicity, we'll let Vite handle the index.html loading
      ;(req as any).inertiaPage = page
      next()
    }
    next()
  }

  app.use(inertia as any)

  // API Routes
  app.post('/api/login', (req, res) => {
    const { email, password } = req.body
    const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email) as any
    if (user && user.password === password) {
      res.json({ token: 'mock-token-' + user.id })
    } else {
      res.status(401).json({ message: 'Invalid credentials' })
    }
  })

  app.get('/api/categories', (req, res) => {
    const categories = db.prepare('SELECT * FROM categories').all()
    res.json({ data: categories })
  })

  app.get('/api/products', (req, res) => {
    const category_id = req.query.category_id
    let query = 'SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id'
    const params: any[] = []
    if (category_id) {
      query += ' WHERE p.category_id = ?'
      params.push(category_id)
    }
    query += ' ORDER BY p.created_at DESC'

    // Pagination (simplified)
    const page = parseInt(req.query.page as string) || 1
    const perPage = 15
    const offset = (page - 1) * perPage

    const count = db.prepare(`SELECT COUNT(*) as count FROM (${query})`).get(...params) as any
    const products = db.prepare(`${query} LIMIT ${perPage} OFFSET ${offset}`).all(...params)

    res.json({
      data: products.map((p: any) => ({
        ...p,
        category: { id: p.category_id, name: p.category_name },
      })),
      meta: {
        current_page: page,
        last_page: Math.ceil(count.count / perPage),
        total: count.count,
      },
    })
  })

  app.get('/api/products/:id', (req, res) => {
    const product = db.prepare('SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.id = ?').get(req.params.id) as any
    if (product) {
      res.json({
        data: {
          ...product,
          category: { id: product.category_id, name: product.category_name },
        },
      })
    } else {
      res.status(404).json({ message: 'Product not found' })
    }
  })

  // Protected Routes (Mock Auth)
  const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization?.split(' ')[1]
    if (token && token.startsWith('mock-token-')) {
      next()
    } else {
      res.status(401).json({ message: 'Unauthenticated' })
    }
  }

  app.post('/api/products', authMiddleware, (req, res) => {
    const { name, description, price, category_id } = req.body
    const result = db.prepare('INSERT INTO products (name, description, price, category_id) VALUES (?, ?, ?, ?)').run(name, description, price, category_id)
    res.status(201).json({ id: result.lastInsertRowid })
  })

  app.put('/api/products/:id', authMiddleware, (req, res) => {
    const { name, description, price, category_id } = req.body
    db.prepare('UPDATE products SET name = ?, description = ?, price = ?, category_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?').run(name, description, price, category_id, req.params.id)
    res.json({ status: 'ok' })
  })

  app.delete('/api/products/:id', authMiddleware, (req, res) => {
    db.prepare('DELETE FROM products WHERE id = ?').run(req.params.id)
    res.status(204).end()
  })

  // Inertia Page Routes
  app.get('/', (req, res) => (res as any).inertia('Public/Index'))
  app.get('/product/:id', (req, res) => (res as any).inertia('Public/Show', { id: req.params.id }))
  app.get('/login', (req, res) => (res as any).inertia('Auth/Login'))
  app.get('/admin/products', (req, res) => (res as any).inertia('Admin/Products/Index'))
  app.get('/admin/products/create', (req, res) => (res as any).inertia('Admin/Products/Create'))
  app.get('/admin/products/:id/edit', (req, res) => (res as any).inertia('Admin/Products/Edit', { id: req.params.id }))

  // Vite or Static serving
  if (process.env.NODE_ENV !== 'production') {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: 'spa',
    })

    app.use(vite.middlewares)

    app.get('*', async (req, res, next) => {
      const url = req.originalUrl
      try {
        let template = await vite.transformIndexHtml(
          url,
          `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <script type="module" src="/resources/js/app.js"></script>
    <title>BTH Catalog</title>
</head>
<body>
    <div id="app" data-page='${JSON.stringify((req as any).inertiaPage || { component: 'Public/Index', props: {}, url: '/', version: '1.0.0' })}'></div>
</body>
</html>`,
        )
        res.status(200).set({ 'Content-Type': 'text/html' }).end(template)
      } catch (e: any) {
        vite.ssrFixStacktrace(e)
        next(e)
      }
    })
  } else {
    const distPath = path.join(process.cwd(), 'dist')
    app.use(express.static(distPath))
    app.get('*', (req, res) => {
      // In production, we'd serve the built index.html and inject the data-page
      res.sendFile(path.join(distPath, 'index.html'))
    })
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${PORT}`)
  })
}

startServer()

declare global {
  namespace Express {
    interface Response {
      inertia: (component: string, props?: any) => void
    }
  }
}
