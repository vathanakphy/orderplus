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
}
