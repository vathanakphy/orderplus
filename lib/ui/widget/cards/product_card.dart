import 'package:flutter/material.dart';
import 'package:orderplus/domain/utils/flexible_image.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String title;
  final String imagePath;
  final VoidCallback? onAddTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onAddTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final Color titleColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color buttonColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: [
                Positioned.fill(child: flexibleImage(imagePath)),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onAddTap,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(
              "ID: $id",
              style: TextStyle(fontSize: 14, color: titleColor),
            ),
          ),
        ],
      ),
    );
  }
}
