import 'package:flutter/material.dart';

class HeaderRow extends StatelessWidget {
  final IconData leftIcon;
  final String title;
  final IconData rightIcon;
  final VoidCallback onRightIconPressed;
  final VoidCallback? onLeftIconPressed;

  const HeaderRow({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.rightIcon,
    required this.onRightIconPressed,
    this.onLeftIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(leftIcon, size: 32, color: Colors.black),
          onPressed: onLeftIconPressed ?? () => Navigator.pop(context),
        ),
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
          icon: Icon(rightIcon, size: 32, color: Colors.black),
          onPressed: onRightIconPressed,
        ),
      ],
    );
  }
}
