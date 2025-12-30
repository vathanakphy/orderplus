import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}
