import 'dart:io';
import 'package:flutter/material.dart';

Widget flexibleImage(
  String imagePath, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  Widget fallback = Container(
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
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
