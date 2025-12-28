import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/utils/time_handle.dart';
import '../widget/order_queue_card.dart';

class OrderQueueScreen extends StatefulWidget {
  final OrderService orderService;

  const OrderQueueScreen({super.key, required this.orderService});

  @override
  State<OrderQueueScreen> createState() => _OrderQueueScreenState();
}

class _OrderQueueScreenState extends State<OrderQueueScreen> {
  late List<Order> _queuedOrders;

  @override
  void initState() {
    super.initState();
    _loadQueuedOrders();
  }

  void _loadQueuedOrders() {
    _queuedOrders = widget.orderService.getOrdersByStatus(OrderStatus.queued);
  }

  void _markServed(Order order) {
    setState(() {
      order.markServed();
      _queuedOrders.remove(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_queuedOrders.isEmpty) {
      return const Center(
        child: Text(
          "No orders in the queue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _queuedOrders.length,
      itemBuilder: (_, index) {
        final order = _queuedOrders[index];
        final summary = order.items
            .map((i) => "${i.quantity}x ${i.product.name}")
            .join(", ");

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OrderQueueCard(
            tableLabel: order.tableNumber != null
                ? "Table ${order.tableNumber}"
                : "Customer / Pickup : ${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}",
            orderNumber: order.hashCode.toString(),
            timeAgo: formatTimeAgo(order.createdAt),
            itemsSummary: summary,
            isNew: order.status == OrderStatus.queued,
            status: order.status,
            isPaid: order.isPaid,
            onActionTap: () => _markServed(order), 
            onTap: null, 
          ),
        );
      },
    );
  }
}
