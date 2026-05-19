<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;
class ProductController extends Controller
{
    public function index(Request $request)
    {
        $products = Product::with('category')
            ->when($request->category_id, fn($q, $categoryId) => $q->where('category_id', $categoryId))
            ->paginate(15);
        return ProductResource::collection($products);
    }
    public function store(StoreProductRequest $request)
    {
        $product = Product::create($request->validated());
        return new ProductResource($product->load('category'));
    }
    public function show(Product $product)
    {
        return new ProductResource($product->load('category'));
    }
    public function update(UpdateProductRequest $request, Product $product)
    {
        $product->update($request->validated());
        return new ProductResource($product->load('category'));
    }
    public function destroy(Product $product)
    {
        $product->delete();
        return response()->json(null, 204);
    }
}
