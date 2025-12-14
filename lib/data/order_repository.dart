import 'package:orderplus/domain/model/order.dart';

class OrderRepository {
  final List<Order> _orders = [];
  final List<int> _tables = [];

  void addTables(List<int> tables) => _tables.addAll(tables);

  void addOrder(Order order) => _orders.add(order);

  void removeOrder(Order order) => _orders.remove(order);

  List<Order> getAllOrders() => List.unmodifiable(_orders);

  List<int> getAllTables() => List.unmodifiable(_tables);
}
