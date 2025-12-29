import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/ui/widget/inputs/icon_button.dart';
import 'package:orderplus/ui/widget/inputs/quantity_button.dart';

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

  bool _isAssetImage(String path) {
    return path.startsWith('assets/');
  }

  Widget _buildProductImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 50,
        height: 50,
        color: Colors.grey[200],
        child: _isAssetImage(imagePath)
            ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackImage(),
              )
            : Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackImage(),
              ),
      ),
    );
  }

  Widget _fallbackImage() {
    return const Icon(
      Icons.fastfood,
      color: Colors.grey,
      size: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;

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

          // Items list
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
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            leading: _buildProductImage(
                              item.product.imageUrl,
                            ),
                            title: Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                QuantityButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity -= 1;
                                      } else {
                                        cartItems.removeAt(index);
                                      }
                                      _checkEmptyAndClose();
                                    });
                                  },
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 30),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${item.quantity}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                QuantityButton(
                                  icon: Icons.add,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  iconColor: Colors.white,
                                  onPressed: () => setState(
                                    () => item.quantity += 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index != cartItems.length - 1)
                            const Divider(height: 1),
                        ],
                      );
                    },
                  ),
          ),

          const SizedBox(height: 24),

          // Confirm button
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
