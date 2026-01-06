import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import '../widget/inputs/selection_bar.dart';
import '../widget/cards/product_card.dart';
import '../widget/layout/order_form.dart';
import '../widget/inputs/search_app_bar.dart';

class OrderScreen extends StatefulWidget {
  final int tableId;
  final OrderService orderService;
  final ProductService productService;

  const OrderScreen({
    super.key,
    required this.tableId,
    required this.orderService,
    required this.productService,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedCategory = "All";
  String _searchQuery = "";

  void _addToCart(Product product) {
    widget.orderService.addToCart(widget.tableId, product);
    setState(() {});
  }

  Future<void> _openCheckout() async {
    final cartItems = widget.orderService.getCartItems();
    if (cartItems.isEmpty) return;

    final orderItems = await showModalBottomSheet<List<OrderItem>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => OrderForm(cartItems: cartItems),
    );

    if (orderItems == null || orderItems.isEmpty) return;

    final success = await widget.orderService.placeOrder(
      tableId: widget.tableId,
      items: orderItems,
    );
    if (!success) return;

    widget.orderService.clearCart();
    setState(() {});

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order placed successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.productService.getAllCategoriesString();
    List<Product> filteredProducts = widget.productService.filterProducts(
      category: widget.productService.getCategoryByName(_selectedCategory),
      searchQuery: _searchQuery,
    );
    final cartItems = widget.orderService.getCartItems();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SearchAppBar(
          title: widget.tableId == -1
              ? "Pickup Order"
              : "Table ${widget.tableId} Order",
          onSearchChanged: (query) => setState(() => _searchQuery = query),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectionBar(
                        items: categories,
                        selectedItem: _selectedCategory,
                        onItemSelected: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: (filteredProducts.isEmpty)
                            ? Center(
                                child: Text(
                                  "No products found.",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.only(bottom: 90),
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 220,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.80,
                                    ),
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  final quantity = widget.orderService
                                      .getQuantity(widget.tableId, product);
                                  return Stack(
                                    children: [
                                      ProductCard(
                                        id: product.id,
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
                if (cartItems.isNotEmpty)
                  Positioned(
                    bottom: 70,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: _openCheckout,
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: Text(
                        "Checkout (${cartItems.fold<int>(0, (sum, i) => sum + i.quantity)})",
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
