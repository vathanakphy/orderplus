import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/enum.dart'; // OrderStatus
import 'package:orderplus/ui/widget/icon_button.dart';

class ProductQueueCard extends StatelessWidget {
  final String orderNumber;
  final String timeAgo;
  final String itemsSummary;
  final bool isNew;
  final OrderStatus status;
  final bool isPaid;
  final VoidCallback? onActionTap;

  const ProductQueueCard({
    super.key,
    required this.orderNumber,
    required this.timeAgo,
    required this.itemsSummary,
    this.isNew = false,
    this.status = OrderStatus.queued,
    this.isPaid = true,
    this.onActionTap,
  });

  String getStatusText() {
    switch (status) {
      case OrderStatus.queued:
        return "Queued";
      case OrderStatus.served:
        return "Served";
      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }

  Color getBadgeBgColor() {
    switch (status) {
      case OrderStatus.queued:
        return const Color(0xFFFFCC80);
      case OrderStatus.served:
        return const Color(0xFFC8E6C9);
      case OrderStatus.cancelled:
        return const Color(0xFFEEEEEE);
    }
  }

  Color getBadgeTextColor() {
    switch (status) {
      case OrderStatus.queued:
        return const Color(0xFFE65100);
      case OrderStatus.served:
        return const Color(0xFF2E7D32);
      case OrderStatus.cancelled:
        return Colors.grey;
    }
  }

  String getButtonText() {
    switch (status) {
      case OrderStatus.queued:
        return "Mark as Served";
      case OrderStatus.served:
        return "Completed";
      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }

  Color getButtonColor() {
    if (status == OrderStatus.served || status == OrderStatus.cancelled) {
      return Colors.greenAccent.shade700;
    }
    return const Color(0xFFE86A12);
  }

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFF1D1B20);
    const Color subtitleColor = Color(0xFF757575);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #$orderNumber",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (isNew && status == OrderStatus.queued)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0B2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "New",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE65100)),
                            ),
                          )
                        else if (status != OrderStatus.queued &&
                            status != OrderStatus.cancelled)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: getBadgeBgColor(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              getStatusText(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: getBadgeTextColor()),
                            ),
                          ),
                        Row(
                          children: [
                            Icon(
                              isPaid
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              size: 16,
                              color: isPaid ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isPaid ? "Paid" : "Unpaid",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isPaid ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemsSummary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomIconButton(
                  text: getButtonText(),
                  height: 48,
                  color: getButtonColor(),
                  textColor: Colors.white,
                  onPressed: status == OrderStatus.served ||
                          status == OrderStatus.cancelled
                      ? null
                      : onActionTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
