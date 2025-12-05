import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  final VoidCallback? onAddNote;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const OrderItem({
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
    // Colors extracted from reference
    const Color titleColor = Color(0xFF1D1B20);
    const Color noteColor = Color(0xFF9E8A78); 
    const Color accentColor = Color(0xFFE86A12); 
    const Color pillBackground = Color(0xFFF4EFE9); 

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent, 
        // borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onAddNote,
                  child: const Text(
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
                    _QuantityButton(
                      icon: Icons.remove,
                      color: accentColor,
                      onTap: onDecrement,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _QuantityButton(
                      icon: Icons.add,
                      color: accentColor,
                      onTap: onIncrement,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),

              // Price
              Text(
                "\$${price.toStringAsFixed(2)}",
                style: const TextStyle(
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

// Helper widget for the small plus/minus buttons
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }
}