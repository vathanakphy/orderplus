import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/product.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  List<Product> getAllProducts() => _repository.products;
  List<String> getAllCategories() =>
      ["All", "Top"] + _repository.categories;

  List<Product> getAvailableProducts() => filterProducts(isAvailable: true);
  List<Product> getUnavailableProducts() => filterProducts(isAvailable: false);

  List<Product> getProductsByCategory(String category) =>
      _repository.products
          .where((p) => p.category == category)
          .toList();

  List<Product> getAvailableByCategory(String category) =>
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
  Future<void> addCategory(String category) async {
    await _repository.addCategory(category);
  }

  List<Product> filterProducts({
    String category = "All",
    String searchQuery = "",
    bool isAvailable = true,
  }) {
    return _repository
        .getAll(
          category: category == "All" ? null : category,
          searchQuery: searchQuery,
        )
        .where((p) => p.isAvailable == isAvailable)
        .toList();
  }
}
