import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/category.dart';
import 'package:orderplus/domain/model/product.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  List<Product> getAllProducts() => _repository.products;
  List<Category> getAllCategories() =>
      [Category(id: 0, name: "All")] + _repository.categories.toList();
  List<String> getAllCategoriesString() =>
      ["All"] + _repository.categories.map((c) => c.name).toList();
  List<Category> get categories => _repository.categories;
  List<Product> getAvailableProducts() => filterProducts(isAvailable: true);
  List<Product> getUnavailableProducts() => filterProducts(isAvailable: false);
  Category? getCategoryByName(String name) =>
      _repository.getCategoryByName(name);
      
  List<Product> getProductsByCategory(String category) =>
      _repository.products
          .where((p) => p.category.name == category)
          .toList();

  List<Product> getAvailableByCategory(Category category) =>
      filterProducts(category: category, isAvailable: true);

  Future<void> deleteProduct(Product product) async {
    await _repository.removeById(product.id);
  }

  Future<void> addProduct(Product product) async {
    await _repository.add(product);
  }

  Future<void> updateProduct(Product updatedProduct) async {
    await _repository.update(updatedProduct);
  }
  Future<void> updateCategory(String oldName, String newName) async {
    await _repository.updateCategory(oldName, newName);
  }
  Future<void> addCategory(String category) async {
    await _repository.addCategory(category);
  }

  List<Product> filterProducts({
    Category? category,
    String searchQuery = "",
    bool isAvailable = true,
  }) {
    return _repository
        .getAll(
          categoryId: (category == null || category.name == "All") ? null : category.id,
          searchQuery: searchQuery,
        )
        .where((p) => p.isAvailable == isAvailable)
        .toList();
  }
}
