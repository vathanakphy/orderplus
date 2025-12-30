import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';

class OrderService {
  final OrderRepository _repository;
  final Map<int, List<OrderItem>> _tableCarts = {};

  OrderService({required OrderRepository repository})
    : _repository = repository;

  // Cart
  void addToCart(int tableId, Product product) {
    final cart = _tableCarts.putIfAbsent(tableId, () => []);
    final existingItem = cart.firstWhere(
      (i) => i.product.id == product.id,
      orElse: () =>
          OrderItem(product: product, quantity: 0, priceAtOrder: product.price),
    );
    if (cart.contains(existingItem)) {
      existingItem.quantity += 1;
    } else {
      existingItem.quantity = 1;
      cart.add(existingItem);
    }
  }

  int getQuantity(int tableId, Product product) {
    final cart = _tableCarts[tableId] ?? [];
    final item = cart.firstWhere(
      (i) => i.product.id == product.id,
      orElse: () =>
          OrderItem(product: product, quantity: 0, priceAtOrder: product.price),
    );
    return item.quantity;
  }

  List<OrderItem> getCartItems(int tableId) =>
      List.from(_tableCarts[tableId] ?? []);

  void clearCart(int tableId) => _tableCarts[tableId]?.clear();

  // Orders

  Future<bool> placeOrder({
    required int tableId,
    required List<OrderItem> items,
  }) async {
    if (items.isEmpty) return false;

    final activeOrder = getCurrentOrdersByTable(tableId);

    if (activeOrder != null) {
      for (var item in items) {
        final index = activeOrder.items.indexWhere(
          (i) => i.product.id == item.product.id,
        );
        if (index != -1) {
          activeOrder.items.elementAt(index).quantity += item.quantity;
          continue;
        }
        activeOrder.addItem(item.product, item.quantity, note: item.note);
      }
    } else {
      final newOrder = Order(
        id: getAllOrders().length + 1,
        tableNumber: tableId,
      );
      for (var item in items) {
        newOrder.addItem(item.product, item.quantity, note: item.note);
      }
      await _repository.addUsedTable(tableId);
      _repository.addOrder(newOrder);
    }

    return true;
  }

  void payOrder(Order order) {
    order.markPaid();
    _repository.removeUsedTable(order.tableNumber);
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
            o.tableNumber != -1 &&
            o.paymentStatus != PaymentStatus.paid,
      );
    } catch (e) {
      return null;
    }
  }

  // Tables
  List<int> getBusyTables() => _repository.usedTables;

  bool isTableBusy(int tableNumber) {
    final used = _repository.usedTables;
    return used.contains(tableNumber);
  }

  List<int> get tables => _repository.tables;

  Future<void> addTable(int newId) async => _repository.addTable(newId);
  Future<void> removeTable(int id) async => _repository.removeTable(id);

  List<Order> filterOrders({PaymentStatus? paymentStatus, String? idQuery}) {
    List<Order> filtered = _repository.orders;

    if (paymentStatus != null) {
      filtered = filtered
          .where((o) => o.paymentStatus == paymentStatus)
          .toList();
    }

    if (idQuery != null && idQuery.isNotEmpty) {
      filtered = filtered
          .where((o) => o.id.toString().contains(idQuery))
          .toList();
    }
    return filtered;
  }
}
