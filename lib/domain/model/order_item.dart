import 'package:orderplus/domain/model/product.dart';

class OrderItems {
  final String id;
  final Product product; 
  final int quantity;
  final String? note;
  final double priceAtOrder;

  OrderItems({
    required this.id,
    required this.product,
    required this.quantity,
    required this.priceAtOrder,
    this.note,
  });
  double get subtotal => priceAtOrder * quantity;
  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      priceAtOrder: (json['priceAtOrder'] as num).toDouble(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(), // serialize product
      'quantity': quantity,
      'priceAtOrder': priceAtOrder,
      'note': note,
    };
  }
}
