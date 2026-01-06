import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';
import 'package:orderplus/ui/widget/inputs/delete_alert.dart';
import 'package:orderplus/ui/widget/inputs/labeled_text_field.dart';
import 'package:orderplus/ui/widget/inputs/search_app_bar.dart';
import '../widget/layout/product_tile.dart';
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
  void dispose() {
    super.dispose();
  }

  Future<void> _showAddProductModal() async {
    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => AddItemModal(productService: widget.productService),
    );

    if (product != null) {
      await widget.productService.addProduct(product);
      setState(() {});
    }
  }

  Future<void> _editProduct(Product product) async {
    final updated = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => AddItemModal(
        productService: widget.productService,
        initialProduct: product,
      ),
    );

    if (updated != null) {
      await widget.productService.updateProduct(updated);
      setState(() {});
    }
  }

  void _deleteProduct(Product product) async {
    final confirmed = await showDeleteDialog(
      context: context,
      title: "Confirm Deletion",
      content: "Are you sure you want to delete '${product.name}'?",
    );
    if (!mounted) return;
    if (confirmed == true) {
      await widget.productService.deleteProduct(product);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product '${product.name}' deleted")),
      );
      setState(() {});
    }
  }

  Future<void> updateCategory(String oldName, String newName) async {
    await widget.productService.updateCategory(oldName, newName);
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.productService.categories;
    final products = _searchQuery.isEmpty
        ? widget.productService.getAllProducts()
        : widget.productService.filterProducts(searchQuery: _searchQuery);
    final categoryController = TextEditingController();
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
                  child: FlexibleImage(
                    imagePath: "assets/app_logo.png",
                    fit: BoxFit.fitWidth,
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
              child: (products.isEmpty)
                  ? Center(
                      child: Text(
                        "No products found.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == categories.length) {
                          return const SizedBox(height: 80);
                        }
                        final category = categories[index];
                        final categoryProducts = products
                            .where((p) => p.category.id == category.id)
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    categoryController.text = category.name;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Category'),
                                          content: SizedBox(
                                            height: 60,
                                            child: LabeledTextField(
                                              controller: categoryController,
                                              hintText: 'Category Name',
                                              labelColor: Colors.black,
                                              fillColor: Colors.grey.shade200,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await updateCategory(
                                                  category.name,
                                                  categoryController.text,
                                                );
                                                if (context.mounted)
                                                  Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            for (final product in categoryProducts)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ProductTile(
                                  title: product.name,
                                  price: product.price,
                                  imagePath: product.imageUrl,
                                  onEdit: () => _editProduct(product),
                                  onDelete: () => _deleteProduct(product),
                                ),
                              ),
                            const SizedBox(height: 25),
                          ],
                        );
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
