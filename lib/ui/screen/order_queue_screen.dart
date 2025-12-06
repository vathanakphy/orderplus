import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/order_queue_card.dart';

class OrderQueueScreen extends StatefulWidget {
  const OrderQueueScreen({super.key});

  @override
  State<OrderQueueScreen> createState() => _OrderQueueScreenState();
}

class _OrderQueueScreenState extends State<OrderQueueScreen> {
  // Orders with actual DateTime
  List<Map<String, dynamic>> orders = [
    {
      "id": "1022",
      "time": DateTime.now().subtract(const Duration(minutes: 12)),
      "items": "1x Salad, 1x Water",
      "status": OrderStatus.ready,
      "isNew": false,
      "isPaid": true,
    },
    {
      "id": "1023",
      "time": DateTime.now().subtract(const Duration(minutes: 8)),
      "items": "1x Pizza, 1x Coke",
      "status": OrderStatus.inProgress,
      "isNew": false,
      "isPaid": false,
    },
    {
      "id": "1024",
      "time": DateTime.now().subtract(const Duration(minutes: 2)),
      "items": "2x Burger, 1x Fries",
      "status": OrderStatus.waiting,
      "isNew": true,
      "isPaid": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    orders.sort((a, b) => a['time'].compareTo(b['time']));
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
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ProductQueueCard(
            orderNumber: order["id"],
            timeAgo: formatTimeAgo(order["time"]),
            itemsSummary: order["items"],
            isNew: order["isNew"],
            status: order["status"],
            isPaid: order["isPaid"],
            onActionTap: () {
              setState(() {
                if (order["status"] == OrderStatus.waiting) {
                  order["status"] = OrderStatus.inProgress;
                } else if (order["status"] == OrderStatus.inProgress) {
                  order["status"] = OrderStatus.ready;
                } else if (order["status"] == OrderStatus.ready) {
                  order["status"] = OrderStatus.complete;
                }
              });
            },
          );
        },
      ),
    );
  }
}
