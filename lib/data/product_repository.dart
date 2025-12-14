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

  List<Product> getAll() => List.unmodifiable(_products);
  List<String> getAllCategories() => List.unmodifiable(_categories);

  addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
    }
  }

}
