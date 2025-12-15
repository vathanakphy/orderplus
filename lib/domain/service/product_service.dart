import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/product.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  List<Product> getAllProducts() => _repository.getAll();
  List<String> getAllCategories() =>
      ["All", "Top"] + _repository.getAllCategories();

  List<Product> getAvailableProducts() =>
      _repository.getAll().where((p) => p.isAvailable).toList();

  List<Product> getUnavailableProducts() =>
      _repository.getAll().where((p) => !p.isAvailable).toList();

  List<Product> getProductsByCategory(String category) =>
      _repository.getAll().where((p) => p.category == category).toList();

  List<Product> getAvailableByCategory(String category) => _repository
      .getAll()
      .where((p) => p.category == category && p.isAvailable)
      .toList();

  void markAvailable(Product product) => product.markAvailable();
  void markUnavailable(Product product) => product.markUnavailable();

  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _repository.getAll()
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
