import 'package:flutter/material.dart';

class ProductInfoTile extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final double height;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductInfoTile({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.height = 90,
    this.onEdit,
    this.onDelete,
  });

  static const Color _brownColor = Color(0xFF9C7349);
  static const Color _titleColor = Color(0xFF1D1B20);

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: _titleColor,
  );

  static const TextStyle _priceStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: _brownColor,
  );

  Widget get _actionButtons => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: _brownColor,
            iconSize: 28,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: _brownColor,
            iconSize: 28,
            onPressed: onDelete,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _brownColor, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
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
                  style: _titleStyle,
                ),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: _priceStyle,
                ),
              ],
            ),
          ),
          _actionButtons,
        ],
      ),
    );
  }
}
