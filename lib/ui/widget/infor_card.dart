import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData? icon;
  final String title;
  final String value;
  final double height;

  const InfoCard({
    super.key,
    required this.color,
    required this.iconColor,
    this.icon,
    required this.title,
    required this.value,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: iconColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(icon, color: iconColor, size: 32),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4), 
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
