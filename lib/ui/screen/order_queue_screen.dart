import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/providers.dart';
import 'package:orderplus/ui/widget/order_queue_card.dart';

class OrderQueueScreen extends ConsumerWidget {
  const OrderQueueScreen({super.key});

  String formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderService = ref.watch(orderServiceProvider);

    final orders = orderService.getOrdersByStatus(OrderStatus.queued)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Kitchen Queue",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (_, index) {
              final order = orders[index];
              final itemsSummary = order.items
                  .map((i) => "${i.quantity}x ${i.product.name}")
                  .join(", ");

              return ProductQueueCard(
                orderNumber: order.hashCode.toString(),
                timeAgo: formatTimeAgo(order.createdAt),
                itemsSummary: itemsSummary,
                isNew: order.status == OrderStatus.queued,
                status: order.status,
                isPaid: order.isPaid,
                onActionTap: () {
                  order.markServed();
                  ref.invalidate(orderServiceProvider); // refresh UI
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
