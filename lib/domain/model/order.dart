import 'package:orderplus/domain/model/order_item.dart';

enum OrderStatus { pending, inProgress, completed }

enum PaymentStatus { unpaid, paid }

class Order {
  final String id;
  final int tableNumber;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final List<OrderItems> items; 

  Order({
    required this.id,
    required this.tableNumber,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.unpaid,
    this.items = const [],
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      tableNumber: json['tableNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.unpaid,
      ),
      items: (json['items'] as List).map((i) => OrderItems.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }
}
