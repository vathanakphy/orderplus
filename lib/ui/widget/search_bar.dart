import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;
  const SearchBarComponent({
    super.key,
    this.onChanged,
    this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    const Color barBackground = Color(0xFFF4EFE9); 
    const Color iconColor = Color(0xFF8D6E63); 
    const Color textColor = Color(0xFF5D4037); 
    const Color placeholderColor = Color(0xFF8D6E63);

    return Container(
      decoration: BoxDecoration(
        color: barBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        cursorColor: textColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: placeholderColor,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: iconColor,
            size: 26,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          isDense: true,
        ),
      ),
    );
  }
}