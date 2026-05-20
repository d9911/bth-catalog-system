/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './resources/js/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        'brand-green': '#00ED64',
        'brand-green-dark': '#00684A',
        'brand-teal-deep': '#001E2B',
        canvas: '#FFFFFF',
        ink: '#001E2B',
        slate: '#5C6C75',
        hairline: '#E8EDEB',
      },
      borderRadius: {
        lg: '12px',
        full: '9999px',
      },
      fontFamily: {
        euclid: ['Euclid Circular A', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
