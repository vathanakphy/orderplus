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
    for (var order in _repository.getAllOrders()) {
      if (_isOrderUsingTable(order)) {
        _usedTables.add(order.tableNumber!);
      }
    }
  }

  void payOrder(Order order) {
    order.markPaid();
    _usedTables.remove(order.tableNumber);
  }

  bool addOrder(Order order) {
    final table = order.tableNumber;
    if (table != null && isTableBusy(table)) return false;
    _repository.addOrder(order);
    if (_isOrderUsingTable(order)) _usedTables.add(table!);
    return true;
  }

  void removeOrder(Order order) {
    _repository.removeOrder(order);
    final table = order.tableNumber;
    if (table != null) {
      final stillUsed = _repository.getAllOrders().any(
        (o) => o.tableNumber == table && _isOrderUsingTable(o),
      );
      if (!stillUsed) _usedTables.remove(table);
    }
  }

  List<Order> getAllOrders() => _repository.getAllOrders();

  List<Order> getOrdersByStatus(OrderStatus status) =>
      _repository.getAllOrders().where((o) => o.status == status).toList();

  List<Order> getOrdersByPaymentStatus(PaymentStatus status) => _repository
      .getAllOrders()
      .where((o) => o.paymentStatus == status && o.status == OrderStatus.served)
      .toList();

  List<Order> getOrdersByTable(int tableNumber) => _repository
      .getAllOrders()
      .where((o) => o.tableNumber == tableNumber)
      .toList();

  List<int> getBusyTables() => _usedTables.toList();

  List<int> getFreeTables() => _repository
      .getAllTables()
      .where((t) => !_usedTables.contains(t))
      .toList();

  bool isTableBusy(int tableNumber) => _usedTables.contains(tableNumber);

  bool isTableFree(int tableNumber) => !isTableBusy(tableNumber);

  bool _isOrderUsingTable(Order order) {
    return order.tableNumber != null &&
        order.status != OrderStatus.cancelled &&
        order.status != OrderStatus.served;
  }

  List<int> get tables => _repository.getAllTables();
  void addTable(newId) => _repository.addTables(newId);
}
