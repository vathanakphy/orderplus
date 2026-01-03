import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';

class Order {
  final int id;
  final DateTime createdAt;
  final int tableNumber;
  List<OrderItem> _items;
  OrderStatus _status;
  PaymentStatus _paymentStatus;

  Order({required this.tableNumber, required this.id})
    : createdAt = DateTime.now(),
      _status = OrderStatus.queued,
      _paymentStatus = PaymentStatus.unpaid,
      _items = [];
  Order.load(
    this.tableNumber,
    this.id,
    this.createdAt,
    this._paymentStatus,
    this._status,
    this._items,
  );
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
  void loadItemFromDB(OrderItem item) {
    _items.add(item);
  }

  void markPaid() => _paymentStatus = PaymentStatus.paid;

  void removeItem(OrderItem item) {
    _items.remove(item);
  }

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.subtotal);

  void markReady() => _status = OrderStatus.ready;
  void cancel() => _status = OrderStatus.cancelled;

  bool get isPaid => _paymentStatus == PaymentStatus.paid;
  bool get isCancelled => _status == OrderStatus.cancelled;
  Map<String, dynamic> toMap() => {
    'id': id,
    'tableNumber': tableNumber,
    'status': _status.name,
    'paymentStatus': _paymentStatus.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order.load(
      map['tableNumber'] as int,
      map['id'] as int,
      map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      PaymentStatus.values.firstWhere(
        (e) => e.name == map['paymentStatus'],
        orElse: () => PaymentStatus.unpaid,
      ),
      OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.ready,
      ),
      [],
    );
  }
}
