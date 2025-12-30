import 'package:orderplus/data/app_database.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository {
  final List<Product> _products = [];
  List<String> _categories = ['All'];
  static const _categoriesKey = 'categories';
  ProductRepository();

  Future<void> init() async {
    final db = await AppDatabase.database;
    final query = await db.query('products');
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
    return _products
        .where(
          (p) =>
              p.isAvailable ||
              _categories.contains(p.category) ||
              p.id.toString().contains(searchQuery ?? '') ||
              p.name.toLowerCase().contains((searchQuery ?? '').toLowerCase()),
        )
        .toList();
  }

  get products => _products;

  Future<void> add(Product product) async {
    final db = await AppDatabase.database;
    await db.insert('products', product.toMap());
    _products.add(product);
  }

  Future<void> removeById(int id) async {
    final db = await AppDatabase.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
    _products.removeWhere((p) => p.id == id);
  }

  Future<void> update(Product product) async {
    final db = await AppDatabase.database;
    await db.update(
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

    final db = await AppDatabase.database;
    await db.delete('products');
  }

  // Categories
  Future<void> saveCategories(List<String> categories) async {
    _categories = categories;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, categories);
  }

  List<String> get categories => _categories;
}
