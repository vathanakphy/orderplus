import 'dart:io';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imagePath; // asset OR file path
  final VoidCallback? onAddTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onAddTap,
  });

  bool get _isAsset => imagePath.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFF1D1B20);
    const Color buttonColor = Color(0xFFE86A12);

    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: _isAsset
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _fallbackImage(),
                        )
                      : Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _fallbackImage(),
                        ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: InkWell(
                  onTap: onAddTap,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: const BoxDecoration(
                      color: buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }
}
