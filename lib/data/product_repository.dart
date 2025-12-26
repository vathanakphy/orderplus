import 'package:orderplus/domain/model/product.dart';

class ProductRepository {
  final List<Product> _products = [];
  final List<String> _categories = [];

  void add(Product product) {
    _products.add(product);
  }

  void remove(Product product) {
    _products.remove(product);
  }

  List<Product> get products => _products;
  List<String> get categories => _categories;

  addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
    }
  }

}
