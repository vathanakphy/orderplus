import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/product.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  List<Product> getAllProducts() => _repository.products;
  List<String> getAllCategories() => ["All", "Top"] + _repository.categories;

  List<Product> getAvailableProducts() =>
      _repository.products.where((p) => p.isAvailable).toList();

  List<Product> getUnavailableProducts() =>
      _repository.products.where((p) => !p.isAvailable).toList();

  List<Product> getProductsByCategory(String category) =>
      _repository.products.where((p) => p.category == category).toList();

  List<Product> getAvailableByCategory(String category) => _repository.products
      .where((p) => p.category == category && p.isAvailable)
      .toList();

  void markAvailable(Product product) => product.markAvailable();
  void markUnavailable(Product product) => product.markUnavailable();

  void deleteProduct(Product product) {
    _repository.products.remove(product);
  }

  void addProduct(Product product) {
    _repository.products.add(product);
  }

  void updateProduct(Product oldProduct, Product updatedProduct) {
    final index = _repository.products.indexOf(oldProduct);
    if (index != -1) {
      _repository.products[index] = updatedProduct;
    }
  }

  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _repository.products
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
