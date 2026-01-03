import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';

class OrderService {
  final OrderRepository _repository;
  final List<OrderItem> cart = [];

  OrderService({required OrderRepository repository})
    : _repository = repository;

  // Cart
  void addToCart(int tableId, Product product) {
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

  double getTotalEarningsByDate(DateTime date) {
    final ordersByDate = _repository.orders.where((order) {
      final orderDate = order.createdAt;
      return orderDate.year == date.year &&
          orderDate.month == date.month &&
          orderDate.day == date.day &&
          order.paymentStatus == PaymentStatus.paid;
    });

    double total = 0.0;
    for (var order in ordersByDate) {
      total += order.totalAmount;
    }
    return total;
  }

  double getTotalEarningsByMonth(DateTime date) {
    final ordersByMonth = _repository.orders.where((order) {
      final orderDate = order.createdAt;
      return orderDate.year == date.year &&
          orderDate.month == date.month &&
          order.paymentStatus == PaymentStatus.paid;
    });

    double total = 0.0;
    for (var order in ordersByMonth) {
      total += order.totalAmount;
    }
    return total;
  }
  double getTotalEarningsByYear(DateTime date) {
    final ordersByYear = _repository.orders.where((order) {
      final orderDate = order.createdAt;
      return orderDate.year == date.year &&
          order.paymentStatus == PaymentStatus.paid;
    });

    double total = 0.0;
    for (var order in ordersByYear) {
      total += order.totalAmount;
    }
    return total;
  }

  int getQuantity(int tableId, Product product) {
    final item = cart.firstWhere(
      (i) => i.product.id == product.id,
      orElse: () =>
          OrderItem(product: product, quantity: 0, priceAtOrder: product.price),
    );
    return item.quantity;
  }

  List<OrderItem> getCartItems() => List.from(cart);

  void clearCart() => cart.clear();

  // Orders

  Future<bool> placeOrder({
    required int tableId,
    required List<OrderItem> items,
  }) async {
    if (items.isEmpty) return false;

    final activeOrder = getCurrentOrdersByTable(tableId);
    if (activeOrder != null && tableId != -1) {
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
      await _repository.addOrder(newOrder);
    }

    return true;
  }

  Future<void> cancelOrder(Order order) async {
    order.cancel();
    await _repository.updateOrder(order);
    if (order.tableNumber != -1) {
      _repository.removeUsedTable(order.tableNumber);
    }
  }

  Future<void> payOrder(Order order) async {
    order.markPaid();
    if (order.tableNumber != -1) {
      _repository.removeUsedTable(order.tableNumber);
    }
    await _repository.updateOrder(order);
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
            !o.isCancelled,
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

  List<Order> filterOrders({
    PaymentStatus? paymentStatus,
    String? idQuery,
    bool isASC = true,
  }) {
    List<Order> filtered = _repository.orders;

    if (paymentStatus != null) {
      filtered = filtered
          .where((o) => o.paymentStatus == paymentStatus && !o.isCancelled)
          .toList();
    }

    if (idQuery != null && idQuery.isNotEmpty) {
      filtered = filtered
          .where((o) => o.id.toString().contains(idQuery))
          .toList();
    }
    if (!isASC) {
      filtered = filtered.reversed.toList();
    }
    return filtered;
  }
}
