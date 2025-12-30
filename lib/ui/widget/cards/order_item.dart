import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/inputs/quantity_button.dart';

class OrderItemBox extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  final VoidCallback? onAddNote;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const OrderItemBox({
    super.key,
    required this.title,
    required this.price,
    this.quantity = 1,
    this.onAddNote,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.colorScheme.primary; // Use primary from theme
    final noteColor = theme.colorScheme.secondary; // Use secondary from theme
    final accentColor = theme.colorScheme.primary; // Accent matches primary
    final pillBackground = theme.colorScheme.onSecondary.withOpacity(0.3); // Slightly transparent

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onAddNote,
                  child: Text(
                    "+ Add note",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: noteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: pillBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QuantityButton(
                      icon: Icons.remove,
                      color: accentColor,
                      onTap: onDecrement!,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    QuantityButton(
                      icon: Icons.add,
                      color: accentColor,
                      onTap: onIncrement!,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Price
              Text(
                "\$${price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}