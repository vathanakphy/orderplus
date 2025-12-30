import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  final String label;
  final String? statusLabel;
  final Color? statusColor;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final bool showEditOverlay;
  final IconData? icon;
  final Color? titleColor;

  const TableCard({
    super.key,
    required this.label,
    this.onTap,
    this.statusLabel,
    this.statusColor,
    this.color,
    this.onDeleteTap,
    this.showEditOverlay = false, this.icon, this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: statusColor != null ? Border.all(color: statusColor!, width: 2) : null,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              color: color ?? Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 40, color: statusColor ?? Colors.black54),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:titleColor ),
                  ),
                  if (statusLabel != null && statusColor != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      statusLabel!,
                      style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Trash icon overlay
        if (showEditOverlay && onDeleteTap != null)
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onDeleteTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
