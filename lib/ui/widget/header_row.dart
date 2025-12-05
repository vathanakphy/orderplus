import 'package:flutter/material.dart';

class HeaderRow extends StatelessWidget {
  final IconData leftIcon;
  final String title;
  final IconData rightIcon;
  final VoidCallback onRightIconPressed;
  final VoidCallback onLeftIconPressed;

  const HeaderRow({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.rightIcon,
    required this.onRightIconPressed,
    required this.onLeftIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(leftIcon, size: 36, color: Colors.black54),
          onPressed: onLeftIconPressed,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(rightIcon, size: 36, color: Colors.black54),
          onPressed: onRightIconPressed,
        ),
      ],
    );
  }
}
