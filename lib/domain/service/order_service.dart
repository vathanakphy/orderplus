import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';

class OrderService {
  final OrderRepository _repository;
  final Set<int> _usedTables = {};

  OrderService({required OrderRepository repository})
    : _repository = repository {
    _initializeUsedTables();
  }

  void _initializeUsedTables() {
    for (var order in _repository.orders) {
      if (_isOrderUsingTable(order)) {
        _usedTables.add(order.tableNumber);
      }
    }
  }

  void payOrder(Order order) {
    order.markPaid();
    _usedTables.remove(order.tableNumber);
  }

  bool addOrder(Order order) {
    final int table = order.tableNumber;
    if (table != -1 && isTableBusy(table)) return false;
    _repository.addOrder(order);
    if (_isOrderUsingTable(order) && table != -1) {
      _usedTables.add(table);
    }
    return true;
  }

  void removeOrder(Order order) {
    _repository.removeOrder(order);
    final table = order.tableNumber;
    if (table != -1) {
      final stillUsed = _repository.orders.any(
        (o) => o.tableNumber == table && _isOrderUsingTable(o),
      );
      if (!stillUsed) _usedTables.remove(table);
    }
  }

  List<Order> getAllOrders() => _repository.orders;

  List<Order> getOrdersByStatus(OrderStatus status) =>
      _repository.orders.where((o) => o.status == status).toList();

  List<Order> getOrdersByPaymentStatus(PaymentStatus status) =>
      _repository.orders.where((o) => o.paymentStatus == status).toList();

  List<Order> getOrdersByTables(int tableNumber) =>
      _repository.orders.where((o) => o.tableNumber == tableNumber).toList();

  Order? getCurrentOrdersByTable(int tableNumber) {
    try {
      return _repository.orders.firstWhere(
        (o) =>
            o.tableNumber == tableNumber &&
            o.paymentStatus != PaymentStatus.paid &&
            o.status != OrderStatus.cancelled,
      );
    } catch (e) {
      return null;
    }
  }

  List<int> getBusyTables() => _usedTables.where((t) => t > 0).toList();

  List<int> getFreeTables() =>
      _repository.tables.where((t) => !_usedTables.contains(t)).toList();

  bool isTableBusy(int tableNumber) => _usedTables.contains(tableNumber);

  bool isTableFree(int tableNumber) => !isTableBusy(tableNumber);

  bool _isOrderUsingTable(Order order) {
    return order.tableNumber != -1 &&
        order.status != OrderStatus.cancelled &&
        order.paymentStatus != PaymentStatus.paid;
  }

  List<int> get tables => _repository.tables;
  void removeTable(int id) => _repository.tables.remove(id);
  void addTable(int newId) => _repository.addTable(newId);

  List<Order> filterOrders({
    PaymentStatus? paymentStatus,
    String? idQuery, 
  }) {
    List<Order> filtered = _repository.orders;

    if (paymentStatus != null) {
      filtered = filtered
          .where((o) => o.paymentStatus == paymentStatus)
          .toList();
    }

    if (idQuery != null && idQuery.isNotEmpty) {
      final query = idQuery.toLowerCase();
      filtered = filtered
          .where((o) => o.id.toString().contains(query))
          .toList();
    }

    return filtered;
  }
}
