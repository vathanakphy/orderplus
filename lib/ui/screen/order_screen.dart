import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/providers.dart';

import 'package:orderplus/ui/widget/category_filter.dart';
import 'package:orderplus/ui/widget/product_card.dart';
import 'package:orderplus/ui/widget/search_bar.dart';
import 'package:orderplus/ui/widget/order_form.dart';

class OrderScreen extends ConsumerStatefulWidget {
  final int tableId;
  final List<OrderItem> cartItems;
  final VoidCallback onBack;
  final void Function(List<OrderItem>) onCartUpdated;

  const OrderScreen({
    super.key,
    required this.tableId,
    required this.cartItems,
    required this.onBack,
    required this.onCartUpdated,
  });

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  late List<OrderItem> _cartItems;
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _cartItems = List<OrderItem>.from(widget.cartItems);
  }

  ProductService get _productService =>
      ref.read(productServiceProvider);

  OrderService get _orderService =>
      ref.read(orderServiceProvider);

  void _addToCart(Product product) {
    setState(() {
      final existingItem = _cartItems.firstWhere(
        (i) => i.product == product,
        orElse: () => OrderItem(
          product: product,
          quantity: 0,
          priceAtOrder: product.price,
        ),
      );

      if (_cartItems.contains(existingItem)) {
        existingItem.quantity += 1;
      } else {
        existingItem.quantity = 1;
        _cartItems.add(existingItem);
      }

      widget.onCartUpdated(_cartItems);
    });
  }

  int _getQuantity(Product product) {
    return _cartItems
        .firstWhere(
          (i) => i.product == product,
          orElse: () => OrderItem(
            product: product,
            quantity: 0,
            priceAtOrder: product.price,
          ),
        )
        .quantity;
  }

  Future<void> _openCheckout() async {
    if (_cartItems.isEmpty) return;

    final order = await showModalBottomSheet<Order>(
      context: context,
      isScrollControlled: true,
      builder: (_) => OrderForm(cartItems: _cartItems),
    );

    if (order != null) {
      _orderService.addOrder(order);

      setState(() => _cartItems.clear());
      widget.onCartUpdated(_cartItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order placed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = _productService.getAllProducts();

    final displayedProducts = _selectedCategory == "All"
        ? allProducts
        : allProducts
            .where((p) => p.category == _selectedCategory)
            .toList();

    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
              const SizedBox(width: 8),
              Text(
                widget.tableId == -1
                    ? "Pickup Order"
                    : "Table ${widget.tableId} Order",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchBarComponent(
                      hintText: "Search for product",
                    ),
                    const SizedBox(height: 16),
                    CategoryFilter(
                      categories: _productService.getAllCategories(),
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: displayedProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final product = displayedProducts[index];
                          final quantity = _getQuantity(product);

                          return Stack(
                            children: [
                              ProductCard(
                                title: product.name,
                                imageAssetPath: product.imageUrl,
                                onAddTap: () => _addToCart(product),
                              ),
                              if (quantity > 0)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.extended(
                    onPressed: _openCheckout,
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: Text(
                      "Checkout (${_cartItems.fold<int>(
                        0,
                        (sum, i) => sum + i.quantity,
                      )})",
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
