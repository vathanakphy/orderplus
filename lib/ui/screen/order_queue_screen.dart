import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/ui/widget/order_queue_card.dart';
import 'package:orderplus/app_dependencies.dart';

class OrderQueueScreen extends StatefulWidget {
  const OrderQueueScreen({super.key});

  @override
  State<OrderQueueScreen> createState() => _OrderQueueScreenState();
}

class _OrderQueueScreenState extends State<OrderQueueScreen> {
  late OrderService _orderService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderService = AppDependencies.of(context).orderService;
  }

  String formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    final orders = _orderService.getAllOrders()
        .where((o) => o.status != OrderStatus.cancelled)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
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
              setState(() {
                if (order.status == OrderStatus.queued) {
                  order.markServed();
                }
              });
            },
          );
        },
      ),
    );
  }
}
