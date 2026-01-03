import 'package:orderplus/domain/model/category.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductRepository {
  List<Product> _products = [];
  List<Category> _categories = [];
  Database database;

  ProductRepository({required this.database});

  Future<void> init() async {
    _categories = await database
        .query('categories')
        .then((maps) => maps.map((map) => Category.fromMap(map)).toList());
    final productMaps = await database.query('products');
    _products = productMaps.map((map) {
      final categoryId = map['categoryId'] as int;
      final category = _categories.firstWhere((c) => c.id == categoryId);
      return Product.fromMap(map, category);
    }).toList();
  }

  // Products
  List<Product> getAll({
    int? categoryId,
    String? searchQuery,
    bool? isAvailable,
  }) {
    bool matchesAvailability(Product p) =>
        isAvailable == null || p.isAvailable == isAvailable;

    bool matchesCategory(Product p) =>
        categoryId == null || p.category.id == categoryId;

    bool matchesSearch(Product p) {
      if (searchQuery == null || searchQuery.isEmpty) return true;

      final q = searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) || p.id.toString().contains(q);
    }

    return _products
        .where(
          (p) =>
              matchesAvailability(p) && matchesCategory(p) && matchesSearch(p),
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

  Future<void> updateCategory(String oldName, String newName) async {
    final categoryIndex = _categories.indexWhere((c) => c.name == oldName);
    Category updatedCategory = Category(
      id: _categories[categoryIndex].id,
      name: newName,
      isActive: _categories[categoryIndex].isActive,
    );
    _categories[categoryIndex] = updatedCategory;
    await database.update(
      'categories',
      updatedCategory.toMap(),
      where: 'id = ?',
      whereArgs: [_categories[categoryIndex].id],
    );
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
    await database.delete('products');
    await database.delete('categories');
  }

  Future<void> addCategory(String category) async {
    if (!_categories.any((c) => c.name == category)) {
      final newCategory = Category(
        id: _categories.isEmpty ? 1 : _categories.last.id + 1,
        name: category,
        isActive: true,
      );
      _categories.add(newCategory);
      await database.insert('categories', newCategory.toMap());
    }
  }

  List<Category> get categories => _categories;

  Category? getCategoryByName(String name) {
    try {
      return _categories.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }
}
