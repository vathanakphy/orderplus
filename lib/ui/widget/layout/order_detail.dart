import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';

class OrderDetailCard extends StatelessWidget {
  final Order order;
  final bool showMarkAsServed;
  final VoidCallback? onConfirmPayment;
  final OrderService orderService;

  const OrderDetailCard({
    super.key,
    required this.order,
    required this.orderService,
    this.showMarkAsServed = false,
    this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order #${order.hashCode}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              order.tableNumber != -1 ? "Table ${order.tableNumber}" : "Customer / Pickup",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 6),
            const Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            ...order.items.map(
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text("${i.quantity} x ${i.product.name}", style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 6),
            Text("Status: ${order.status.name}", style: const TextStyle(fontSize: 16)),
            Text("Paid: ${order.isPaid ? 'Yes' : 'No'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            if (showMarkAsServed)
              Center(
                child: ElevatedButton(
                  onPressed: order.status != OrderStatus.served
                      ? () {
                          order.markServed();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order marked as served!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  child: const Text("Mark as Served"),
                ),
              ),
            if (!showMarkAsServed && onConfirmPayment != null)
              Center(
                child: ElevatedButton(
                  onPressed: onConfirmPayment,
                  child: const Text("Confirm Payment"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
