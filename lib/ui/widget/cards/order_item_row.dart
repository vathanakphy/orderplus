import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  final String name;
  final int qty;
  final double price;
  final String? image;

  const OrderItemRow({
    super.key,
    required this.name,
    required this.qty,
    required this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: (image != null && image!.isNotEmpty)
                ? Image.asset(
                    image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  )
                : const Icon(Icons.fastfood, color: Colors.grey, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$qty x \$${price.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        Text(
          "\$${(qty * price).toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }
}
