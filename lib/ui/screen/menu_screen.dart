import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/inputs/labeled_text_field.dart';
import '../widget/cards/product_infor.dart';
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
                  LabeledTextField(
                    controller: TextEditingController(text: _searchQuery),
                    hintText: "Search for a menu item...",
                    labelColor: Theme.of(context).textTheme.bodyMedium!.color ?? Colors.black,
                    fillColor: Theme.of(context).colorScheme.secondary.withAlpha((0.1 * 255).round()),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  )
                ],
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
            child: const Icon(Icons.add, color: Colors.white, size: 32),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: AddItemScreen(productService: widget.productService,),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void onDeleteProduct(BuildContext context, Product product) async {
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
              imageUrl: product.imageUrl,
              onEdit: () {},
              onDelete: () async {
                onDeleteProduct(context, product);
              },
            ),
          ),
        const SizedBox(height: 25),
      ],
    );
  }
}
