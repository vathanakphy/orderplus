import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddTap,
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
                Positioned.fill(child: FlexibleImage(imagePath: product.imageUrl)),
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
                      child: Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              product.name,
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
              "ID: ${product.id}",
              style: TextStyle(fontSize: 14, color: titleColor),
            ),
          ),
        ],
      ),
    );
  }
}
