import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/order_item.dart';

class OrderForm extends StatefulWidget {
  final List<OrderItem> cartItems;

  const OrderForm({super.key, required this.cartItems});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Summary",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "${widget.cartItems.fold<int>(0, (sum, i) => sum + i.quantity)} Items",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: widget.cartItems.isEmpty
                ? const Center(child: Text("No items selected"))
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: Image.asset(
                              item.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        title: Text(
                          item.product.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity -= 1;
                                  } else {
                                    widget.cartItems.removeAt(index);
                                  }
                                });
                                // UI will sync with screen after modal closes
                              },
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 30),
                              alignment: Alignment.center,
                              child: Text(
                                "${item.quantity}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                              iconColor: Colors.white,
                              onPressed: () =>
                                  setState(() => item.quantity += 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: widget.cartItems.isEmpty
                ? null
                : () {
                    final order = Order();
                    for (var item in widget.cartItems) {
                      order.addItem(item.product, item.quantity, note: item.note);
                    }
                    Navigator.pop(context, order);
                  },
            child: const Text("Confirm Order"),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? iconColor;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: iconColor ?? Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
