import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import '../widget/product_infor.dart';
import '../widget/search_bar.dart';
import '../screen/add_item_screen.dart';

class MenuScreen extends StatefulWidget {
  final ProductService productService;

  const MenuScreen({super.key, required this.productService});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final categories = widget.productService.getAllCategories();
    final products = _searchQuery.isEmpty
        ? widget.productService.getAllProducts()
        : widget.productService.searchProducts(_searchQuery);

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Menu Management",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SearchBarComponent(
                    hintText: "Search for a menu item...",
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final category in categories)
                    _buildCategorySection(
                      category,
                      products.where((p) => p.category == category).toList(),
                    ),
                  const SizedBox(height: 80),
                ],
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
            child: const Icon(Icons.add, color: Colors.white, size: 32),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  minChildSize: 0.5,
                  maxChildSize: 1,
                  builder: (_, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: AddItemScreen(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String title, List<Product> products) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (final product in products)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductInfoTile(
              title: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        const SizedBox(height: 25),
      ],
    );
  }
}
