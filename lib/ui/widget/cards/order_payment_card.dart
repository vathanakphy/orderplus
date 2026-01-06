import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/utils/time_handle.dart';
import 'package:orderplus/ui/widget/cards/badge.dart';

class OrderPaymentCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderPaymentCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPickup = order.tableNumber == -1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
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
                    "Order #${order.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${isPickup ? "Pickup" : "Table ${order.tableNumber}"} • ${order.items.length} items",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA1887F),
                    ),
                  ),
                  Text(
                    formatTimeAgo(order.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${order.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 8),
                CustomBadge(
                  text: order.isCancelled
                      ? "Cancelled"
                      : order.isPaid
                      ? "Paid"
                      : "Unpaid",
                  bgColor: order.isCancelled
                      ? const Color(0xFFFFEBEE) 
                      : order.isPaid
                      ? const Color(0xFFE8F5E9) 
                      : const Color(0xFFFFF3E0), 
                  textColor: order.isCancelled
                      ? const Color(0xFFD32F2F) 
                      : order.isPaid
                      ? const Color(0xFF2E7D32) 
                      : Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
