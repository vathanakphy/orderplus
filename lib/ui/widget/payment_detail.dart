import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/ui/widget/icon_button.dart';
import 'package:orderplus/ui/widget/order_item_row.dart';

class PaymentDetailSheet extends StatelessWidget {
  final Order order;
  final VoidCallback onConfirmPayment;

  const PaymentDetailSheet({
    super.key,
    required this.order,
    required this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    final items = order.items;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.tableNumber != null
                        ? "Table ${order.tableNumber}"
                        : "Customer",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "#Order ${order.tableNumber ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Icon(Icons.qr_code_2, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Items",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final item = items[index];
                return OrderItemRow(
                  name: item.product.name,
                  qty: item.quantity,
                  price: item.priceAtOrder,
                  image: item.product.imageUrl,
                );
              },
            ),
          ),
          const Divider(thickness: 1, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${order.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (!order.isPaid)
            CustomIconButton(
              text: "Confirm Payment",
              color: const Color(0xFFEF6C00),
              onPressed: onConfirmPayment,
            )
          else
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      "Paid Successfully",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
