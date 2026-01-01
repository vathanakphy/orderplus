import 'package:orderplus/domain/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductRepository {
  final List<Product> _products = [];
  List<String> _categories = ['All'];
  static const _categoriesKey = 'categories';
  Database database;

  ProductRepository({required this.database});

  Future<void> init() async {
    final query = await database.query('products');
    _products.clear();
    _products.addAll(query.map(Product.fromMap));
    final prefs = await SharedPreferences.getInstance();
    _categories = prefs.getStringList(_categoriesKey) ?? ['All'];
  }

  // Products
  List<Product> getAll({
    String? category,
    String? searchQuery,
    bool? isAvailable,
  }) {
    
    bool matchesAvailability(Product p) =>
        isAvailable == null || p.isAvailable == isAvailable;

    bool matchesCategory(Product p) =>
        category == null || category == 'All' || p.category == category;

    bool matchesSearch(Product p) {
      if (searchQuery == null || searchQuery.isEmpty) return true;

      final q = searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) || p.id.toString().contains(q);
    }

    return _products
        .where(
          (p) =>
              matchesAvailability(p) &&
              matchesCategory(p) &&
              matchesSearch(p),
        )
        .toList();
  }

  get products => _products;

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> add(Product product) async {
    await database.insert('products', product.toMap());
    _products.add(product);
  }

  Future<void> removeById(int id) async {
    await database.delete('products', where: 'id = ?', whereArgs: [id]);
    _products.removeWhere((p) => p.id == id);
  }

  Future<void> update(Product product) async {
    await database.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  Future<void> clearData() async {
    _products.clear();
    _categories = ['All'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_categoriesKey);

    await database.delete('products');
  }

  // Categories
  Future<void> saveCategories(List<String> categories) async {
    _categories = categories;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, categories);
  }

  List<String> get categories => _categories;
}
