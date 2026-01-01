import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class OrderRepository {
  Database database;
  SharedPreferences prefs;
  ProductRepository productsRepository;
  List<Order> _orders = [];
  List<int> _tables = [];
  List<int> _usedTables = [];
  static const _tablesKey = 'tables';
  static const _usedTablesKey = 'used_tables';
  OrderRepository({
    required this.database,
    required this.productsRepository,
    required this.prefs,
  });

  Future<void> init() async {
    _tables = await getTables();
    _usedTables = await getUsedTables();
    _orders = await getOrdersFromDB();
  }

  Future<void> addOrder(Order order) async {
    _orders.add(order);
    await database.insert('orders', order.toMap());
    for (var item in order.items) {
      await database.insert('order_items', {
        'orderId': order.id,
        'productId': item.product.id,
        'quantity': item.quantity,
        'priceAtOrder': item.priceAtOrder,
        'note': item.note,
      });
    }
  }

  Future<List<Order>> getOrdersFromDB() async {
    final List<Order> orders = [];
    final orderMaps = await database.query('orders');
    for (var map in orderMaps) {
      final order = Order.fromMap(map);
      final itemsMaps = await database.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [order.id],
      );
      for (var itemMap in itemsMaps) {
        final productId = itemMap['productId'] as int;
        final product = productsRepository.getProductById(productId);
        if (product != null) {
          order.addItem(
            product,
            itemMap['quantity'] as int,
            note: itemMap['note'] as String?,
          );
        }
      }
      orders.add(order);
    }
    return orders;
  }

  Future<void> updateOrder(Order order) async {
    await database.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  List<Order> get orders => _orders;

  List<int> get tables => _tables;

  List<int> get usedTables => _usedTables;

  Future<void> saveTables(List<int> tables) async {
    await prefs.setStringList(
      _tablesKey,
      tables.map((e) => e.toString()).toList(),
    );
  }

  Future<void> addTable(int table) async {
    if (!_tables.contains(table)) {
      _tables.add(table);
      await saveTables(_tables);
    }
  }

  Future<void> removeTable(int table) async {
    _tables.remove(table);
    await saveTables(_tables);
  }

  Future<void> addTables(List<int> tablesToAdd) async {
    _tables.addAll(tablesToAdd);
    await saveTables(_tables);
  }

  Future<void> setUsedTables(List<int> usedTables) async {
    await prefs.setStringList(
      _usedTablesKey,
      usedTables.map((e) => e.toString()).toList(),
    );
  }

  Future<void> addUsedTable(int table) async {
    if (!_usedTables.contains(table)) {
      _usedTables.add(table);
      await setUsedTables(_usedTables);
    }
  }

  Future<void> removeUsedTable(int table) async {
    _usedTables.remove(table);
    await setUsedTables(_usedTables);
  }

  Future<void> clearData() async {
    _tables = [];
    _usedTables = [];
    _orders = [];
    await prefs.remove(_tablesKey);
    await prefs.remove(_usedTablesKey);
    await database.delete('orders');
  }

  Future<List<int>> getTables() async {
    final tables = (prefs.getStringList(_tablesKey) ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
    return tables;
  }

  Future<List<int>> getUsedTables() async {
    final usedTables = (prefs.getStringList(_usedTablesKey) ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
    return usedTables;
  }
}
