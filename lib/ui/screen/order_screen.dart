import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/ui/widget/category_filter.dart';
import 'package:orderplus/ui/widget/product_card.dart';
import 'package:orderplus/ui/widget/search_bar.dart';
import 'package:orderplus/ui/widget/order_form.dart';
import 'package:orderplus/app_dependencies.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<OrderItem> _cartItems = [];
  String _selectedCategory = "All";

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
    });
  }

  int _getQuantity(Product product) {
    final item = _cartItems.firstWhere(
      (i) => i.product == product,
      orElse: () =>
          OrderItem(product: product, quantity: 0, priceAtOrder: product.price),
    );
    return item.quantity;
  }

  Future<void> _openCheckout() async {
    if (_cartItems.isEmpty) return;

    final orderService = AppDependencies.of(context).orderService;
    final order = await showModalBottomSheet<Order>(
      isScrollControlled: true,
      context: context,
      builder: (_) => OrderForm(cartItems: _cartItems),
    );

    if (order != null) {
      orderService.addOrder(order);

      setState(() => _cartItems.clear());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order placed successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final productService = AppDependencies.of(context).productService;
    final allProducts = productService.getAllProducts();

    final displayedProducts = _selectedCategory == "All"
        ? allProducts
        : allProducts.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _openCheckout,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
              ),
              label: Text(
                "Checkout (${_cartItems.fold<int>(0, (sum, i) => sum + i.quantity)})",
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarComponent(hintText: "Search for product"),
            const SizedBox(height: 16),
            CategoryFilter(
              categories: productService.getAllCategories(),
              selectedCategory: _selectedCategory,
              onCategorySelected: (newCategory) {
                setState(() => _selectedCategory = newCategory);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: displayedProducts.length,
                padding: const EdgeInsets.only(bottom: 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  final quantity = _getQuantity(product);

                  return Stack(
                    fit: StackFit.expand,
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
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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
    );
  }
}
