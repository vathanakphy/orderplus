import 'dart:io';

import 'package:flutter/material.dart';

class FlexibleImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const FlexibleImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: Colors.grey[300],
      width: width,
      height: height,
      child: const Icon(Icons.image_not_supported, size: 40),
    );

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => fallback,
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: fit,
        width: width,
        height: height,
        gaplessPlayback: true, 
        errorBuilder: (_, __, ___) => fallback,
      );
    }
  }
}
