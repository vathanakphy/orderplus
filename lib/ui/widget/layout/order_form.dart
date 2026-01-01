import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/ui/widget/layout/order_item_tile.dart';
import 'package:orderplus/ui/widget/inputs/icon_button.dart';

class OrderForm extends StatefulWidget {
  final List<OrderItem> cartItems;

  const OrderForm({super.key, required this.cartItems});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  void addOrderItems() {
    Navigator.pop(context, widget.cartItems.isEmpty ? null : widget.cartItems);
  }

  void _checkEmptyAndClose() {
    if (widget.cartItems.isEmpty) {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Summary",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "${cartItems.fold<int>(0, (sum, i) => sum + i.quantity)} Items",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: cartItems.isEmpty
                ? const Center(child: Text("No items selected"))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OrderItemTile(
                              name: item.product.name,
                              quantity: item.quantity,
                              imagePath: item.product.imageUrl,
                              onAdd: () {
                                setState(() {
                                  item.quantity += 1;
                                });
                              },
                              onRemove: () {
                                setState(() {
                                  item.quantity -= 1;
                                  if (item.quantity <= 0) {
                                    cartItems.removeAt(index);
                                    _checkEmptyAndClose();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          CustomIconButton(
            text: "Confirm Order",
            icon: Icons.check_circle_outline,
            height: 50,
            onPressed: cartItems.isEmpty ? null : addOrderItems,
          ),
        ],
      ),
    );
  }
}
