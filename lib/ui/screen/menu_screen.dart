import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/domain/utils/flexible_image.dart';
import 'package:orderplus/ui/widget/inputs/search_app_bar.dart';
import '../widget/cards/product_infor.dart';
import '../widget/layout/add_item_modal.dart';

class MenuScreen extends StatefulWidget {
  final ProductService productService;

  const MenuScreen({super.key, required this.productService});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showAddProductModal() async {
    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => AddItemScreen(productService: widget.productService),
    );

    if (product != null) {
      widget.productService.addProduct(product);
      setState(() {});
    }
  }

  Future<void> _editProduct(Product product) async {
    final updated = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => AddItemScreen(
        productService: widget.productService,
        initialProduct: product,
      ),
    );

    if (updated != null) {
      widget.productService.updateProduct(product, updated);
      setState(() {});
    }
  }

  void _deleteProduct(BuildContext context, Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete '${product.name}'?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        widget.productService.deleteProduct(product);
      });
    }
  }

  Widget _buildCategorySection(String title, List<Product> products) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        for (final product in products)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductInfoTile(
              title: product.name,
              price: product.price,
              imagePath: product.imageUrl,
              onEdit: () => _editProduct(product),
              onDelete: () => _deleteProduct(context, product),
            ),
          ),
        const SizedBox(height: 25),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.productService.getAllCategories();
    final products = _searchQuery.isEmpty
        ? widget.productService.getAllProducts()
        : widget.productService.filterProducts(searchQuery: _searchQuery);

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchAppBar(
                titleWidget: SizedBox(
                  width: 150,
                  height: 40,
                  child: flexibleImage(
                    "assets/app_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == categories.length) {
                    return const SizedBox(height: 80);
                  }
                  final category = categories[index];
                  final categoryProducts = products
                      .where((p) => p.category == category)
                      .toList();
                  return _buildCategorySection(category, categoryProducts);
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: "addMenuFab",
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: _showAddProductModal,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
