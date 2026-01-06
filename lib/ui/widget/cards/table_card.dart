import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  final String label;
  final String? statusLabel;
  final Color? statusColor;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onOpenOrderDetails;
  final bool showEditOverlay;
  final IconData? icon;
  final Color? titleColor;
  final bool isBusy;
  const TableCard({
    super.key,
    required this.label,
    this.onTap,
    this.statusLabel,
    this.statusColor,
    this.color,
    this.onDeleteTap,
    this.showEditOverlay = false,
    this.icon,
    this.titleColor = Colors.black,
    this.isBusy = true,
    this.onOpenOrderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: statusColor != null
                  ? Border.all(color: statusColor!, width: 2)
                  : null,
              color: color ?? Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        icon,
                        size: 40,
                        color: statusColor ?? Colors.black54,
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: titleColor,
                    ),
                  ),
                  if (statusLabel != null && statusColor != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        statusLabel!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        
        if (showEditOverlay && onDeleteTap != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDeleteTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.delete, size: 20, color: Colors.white),
              ),
            ),
          ),
        if (isBusy && !showEditOverlay)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onOpenOrderDetails,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.receipt, size: 28, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
