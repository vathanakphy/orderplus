import 'dart:io';
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  final String name;
  final int qty;
  final double price;
  final String? imagePath;

  const OrderItemRow({
    super.key,
    required this.name,
    required this.qty,
    required this.price,
    this.imagePath,
  });

  bool get _isAsset =>
      imagePath != null && imagePath!.startsWith('assets/');

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
            child: imagePath == null
                ? const Icon(Icons.fastfood, color: Colors.grey)
                : _isAsset
                    ? Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _fallback(),
                      )
                    : Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _fallback(),
                      ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                "$qty x \$${price.toStringAsFixed(2)}",
                style:
                    TextStyle(color: Colors.grey[600], fontSize: 14),
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

  Widget _fallback() =>
      const Icon(Icons.image_not_supported, color: Colors.grey);
}
