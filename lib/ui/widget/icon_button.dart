import 'package:flutter/material.dart';


class CustomIconButton extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final IconData? icon;
  final String text;
  final double height;
  final VoidCallback? onPressed;

  const CustomIconButton({
    super.key,
    required this.text,
    this.icon,
    this.height = 60,
    this.color,
    this.iconColor,
    this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = color ?? theme.colorScheme.primary;
    final fgIconColor = iconColor ?? theme.colorScheme.onPrimary;
    final fgTextColor = textColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bgColor),
          foregroundColor: WidgetStateProperty.all(fgTextColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStateProperty.all(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(icon, size: 28, color: fgIconColor),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: fgTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}