import 'package:flutter/material.dart';

class OrderPaymentAlert extends StatelessWidget {
  final String orderNumber;
  final String time;
  final double price;
  final VoidCallback? onTap;

  const OrderPaymentAlert({
    super.key,
    required this.orderNumber,
    required this.time,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors extracted from design
    const Color cardBg = Colors.white;
    const Color iconBg = Color(0xFFFFE0B2); 
    const Color iconColor = Color(0xFFF57C00);
    const Color titleColor = Color(0xFF1D1B20);
    const Color timeColor = Color(0xFF9E9E9E); 
    const Color priceColor = Color(0xFF1D1B20);
    const Color borderColor = Color(0xFFEEEEEE);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor,width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded, 
                    color: iconColor,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Order $orderNumber",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Text(
              "\$${price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: priceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}