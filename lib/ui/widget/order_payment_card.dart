import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/badge.dart';

class OrderPaymentCard extends StatelessWidget {
  final String orderNumber;
  final double price;
  final String customerName;
  final int itemCount;
  final bool isPaid;
  final VoidCallback? onTap;

  const OrderPaymentCard({
    super.key,
    required this.orderNumber,
    required this.price,
    required this.customerName,
    required this.itemCount,
    required this.isPaid,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFE9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: Color(0xFF5D4037),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #$orderNumber",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$customerName • $itemCount items",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA1887F),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 8),
                CustomBadge(
                  text: isPaid ? "Paid" : "Unpaid",
                  bgColor: isPaid
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  textColor: isPaid
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFEF6C00),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
