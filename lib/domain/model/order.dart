import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';

class Order {
  final int id;
  final DateTime createdAt;
  final int tableNumber;

  OrderStatus _status;
  PaymentStatus _paymentStatus;

  final List<OrderItem> _items = [];

  Order({required this.tableNumber, required this.id})
    : createdAt = DateTime.now(),
      _status = OrderStatus.served,
      _paymentStatus = PaymentStatus.unpaid;

  List<OrderItem> get items => _items;
  OrderStatus get status => _status;
  PaymentStatus get paymentStatus => _paymentStatus;

  void addItem(Product product, int quantity, {String? note}) {
    if (!product.isAvailable) {
      throw Exception('Product is not available');
    }

    _items.add(
      OrderItem(
        product: product,
        quantity: quantity,
        priceAtOrder: product.price,
        note: note,
      ),
    );
  }

  void markPaid() => _paymentStatus = PaymentStatus.paid;

  void removeItem(OrderItem item) {
    _items.remove(item);
  }

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.subtotal);

  void markServed() => _status = OrderStatus.served;
  void cancel() => _status = OrderStatus.cancelled;

  bool get isPaid => _paymentStatus == PaymentStatus.paid;

  Map<String, dynamic> toMap() => {
    'id': id,
    'tableNumber': tableNumber,
    'status': _status.name,
    'paymentStatus': _paymentStatus.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Order.fromMap(Map<String, dynamic> map) {
    final order = Order(id: map['id'], tableNumber: map['tableNumber']);

    order._status = OrderStatus.values.firstWhere(
      (e) => e.name == map['status'],
    );
    order._paymentStatus = PaymentStatus.values.firstWhere(
      (e) => e.name == map['paymentStatus'],
    );

    return order;
  }
}
