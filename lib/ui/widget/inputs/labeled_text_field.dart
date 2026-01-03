import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String hintText;
  final Color labelColor;
  final Color fillColor;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const LabeledTextField({
    super.key,
    this.label,
    required this.controller,
    required this.hintText,
    required this.labelColor,
    required this.fillColor,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16, color: labelColor),
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: labelColor)
                : null,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
