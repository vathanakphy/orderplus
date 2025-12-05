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

  @override
  Widget build(BuildContext context) {
    final Color brownColor = const Color(0xFF9C7349);
    final Color titleColor = const Color(0xFF1D1B20);

    return Container(
      padding: const EdgeInsets.all(5),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brownColor, width: 1),
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
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: titleColor,
                          ),
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 1, // single line
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          color: brownColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: brownColor,
                      iconSize: 28,
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: brownColor,
                      iconSize: 28,
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
