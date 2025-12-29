import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/inputs/search_bar.dart';
import '../widget/inputs/category_filter.dart';
import '../widget/cards/product_card.dart';
import '../widget/layout/order_form.dart';

class OrderScreen extends StatefulWidget {
  final int tableId;
  final List<OrderItem> cartItems;
  final VoidCallback onBack;
  final void Function(List<OrderItem>) onCartUpdated;
  final OrderService orderService;
  final ProductService productService;

  const OrderScreen({
    super.key,
    required this.tableId,
    required this.cartItems,
    required this.onBack,
    required this.onCartUpdated,
    required this.orderService,
    required this.productService,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late List<OrderItem> _cartItems = [];
  String _selectedCategory = "All";
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _cartItems = List<OrderItem>.from(widget.cartItems);
  }

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

    final orderItems = await showModalBottomSheet<List<OrderItem>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => OrderForm(cartItems: _cartItems),
    );

    if (orderItems == null || orderItems.isEmpty) {
      setState(() {
      });
      return;
    }

    final activeOrder = widget.orderService.getCurrentOrdersByTable(
      widget.tableId,
    );

    if (activeOrder != null) {
      // Push items to existing order
      for (var item in orderItems) {
        activeOrder.addItem(item.product, item.quantity, note: item.note);
      }
    } else {
      // Create a new order
      final newOrder = Order(
        id: widget.orderService.getAllOrders().length + 1,
        tableNumber: widget.tableId,
      );
      for (var item in orderItems) {
        newOrder.addItem(item.product, item.quantity, note: item.note);
      }
      widget.orderService.addOrder(newOrder);
    }

    // Clear local cart
    setState(() => _cartItems.clear());
    widget.onCartUpdated(_cartItems);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = widget.productService.getAllProducts();
    var filteredProducts = _selectedCategory == "All"
        ? allProducts
        : allProducts.where((p) => p.category == _selectedCategory).toList();
    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

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
                    CustomSearchBar(
                      hintText: "Search by order",
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CategoryFilter(
                      categories: widget.productService.getAllCategories(),
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final quantity = _getQuantity(product);
                          return Stack(
                            children: [
                              ProductCard(
                                title: product.name,
                                imagePath: product.imageUrl,
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
                      "Checkout (${_cartItems.fold<int>(0, (sum, i) => sum + i.quantity)})",
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
