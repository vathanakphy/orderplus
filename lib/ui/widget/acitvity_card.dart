import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData? icon;
  final String title;
  final String value;
  final double height;

  const ActivityCard({
    super.key,
    required this.color,
    required this.iconColor,
    this.icon,
    required this.title,
    required this.value,
    this.height = 90, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: iconColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color, 
                    shape: BoxShape.circle, 
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), 
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54, 
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}