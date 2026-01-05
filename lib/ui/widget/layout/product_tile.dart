import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';

class ProductTile extends StatelessWidget {
  final String title;
  final double price;
  final String imagePath;
  final double height;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductTile({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.height = 90,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.primary;
    final titleColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final priceColor = theme.colorScheme.secondary;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlexibleImage(
              imagePath: imagePath,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: priceColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: theme.colorScheme.primary,
                iconSize: 28,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                iconSize: 28,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
