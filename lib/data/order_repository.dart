import 'package:orderplus/domain/model/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final List<Order> _orders = [];
  List<int> _tables = [];
  List<int> _usedTables = [];

  static const _tablesKey = 'tables';
  static const _usedTablesKey = 'used_tables';

  OrderRepository();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    _tables = (prefs.getStringList(_tablesKey) ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();

    _usedTables = (prefs.getStringList(_usedTablesKey) ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
  }

  void addOrder(Order order) => _orders.add(order);
  
  List<Order> get orders => _orders;

  Future<void> saveTables(List<int> tables) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _tablesKey,
      tables.map((e) => e.toString()).toList(),
    );
  }

  List<int> get tables => _tables;
  List<int> get usedTables => _usedTables;

  Future<void> addTable(int table) async {
    final tables = _tables;
    if (!tables.contains(table)) {
      tables.add(table);
      await saveTables(tables);
    }
  }

  Future<void> addTables(List<int> tablesToAdd) async {
    final tables = _tables;
    await saveTables(tables);
    tables.addAll(tablesToAdd);
  }

  Future<void> removeTable(int table) async {
    final tables = _tables;
    tables.remove(table);
    await saveTables(tables);
  }

  Future<void> setUsedTables(List<int> usedTables) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _usedTablesKey,
      usedTables.map((e) => e.toString()).toList(),
    );
  }

  Future<void> addUsedTable(int table) async {
    final used = usedTables;
    if (!used.contains(table)) {
      used.add(table);
      await setUsedTables(used);
    }
  }

  Future<void> removeUsedTable(int table) async {
    final used = usedTables;
    used.remove(table);
    await setUsedTables(used);
  }

  Future<void> clearData() async {
    _tables = [];
    _usedTables = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tablesKey);
    await prefs.remove(_usedTablesKey);
  }
}
