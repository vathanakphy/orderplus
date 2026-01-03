import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';
import 'package:orderplus/ui/widget/inputs/quantity_button.dart';

class OrderItemTile extends StatelessWidget {
  final String name;
  final int quantity;
  final double? price;
  final String? imagePath;

  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const OrderItemTile({
    super.key,
    required this.name,
    required this.quantity,
    this.price,
    this.imagePath,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 56,
            height: 56,
            color: Colors.grey[200],
            child: imagePath == null
                ? const Icon(Icons.fastfood, color: Colors.grey)
                : FlexibleImage(imagePath: imagePath!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (price != null)
                Text(
                  "$quantity x \$${price!.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        if (onAdd != null || onRemove != null)
          Row(
            children: [
              QuantityButton(icon: Icons.remove, onTap: onRemove!),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "$quantity",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              QuantityButton(
                icon: Icons.add,
                color: Theme.of(context).colorScheme.primary,
                iconColor: Colors.white,
                onTap: onAdd!,
              ),
            ],
          ),
        if (price != null)
          Text(
            "\$${(quantity * price!).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
      ],
    );
  }
}
