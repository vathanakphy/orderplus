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

  // Read-only access
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

  void removeItem(OrderItem item) {
    _items.remove(item);
  }

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.subtotal);

  void markServed() => _status = OrderStatus.served;
  void cancel() => _status = OrderStatus.cancelled;

  void markPaid() => _paymentStatus = PaymentStatus.paid;

  bool get isPaid => _paymentStatus == PaymentStatus.paid;
}
