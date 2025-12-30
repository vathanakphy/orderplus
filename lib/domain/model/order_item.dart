import 'package:orderplus/domain/model/product.dart';

class OrderItem {
  final Product product;
  int quantity;
  final double priceAtOrder;
  final String? note;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.priceAtOrder,
    this.note,
  });

  double get subtotal => priceAtOrder * quantity;

  Map<String, dynamic> toMap(int orderId) => {
    'orderId': orderId,
    'productId': product.id,
    'quantity': quantity,
    'priceAtOrder': priceAtOrder,
    'note': note,
  };

  static OrderItem fromMap(Map<String, dynamic> map, Product product) {
    return OrderItem(
      product: product,
      quantity: map['quantity'],
      priceAtOrder: map['priceAtOrder'],
      note: map['note'],
    );
  }
}
