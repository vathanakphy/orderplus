import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/main.dart';
import 'package:orderplus/ui/widget/inputs/image_upload_area.dart';
import 'package:orderplus/ui/widget/inputs/category_selector.dart';
import 'package:orderplus/ui/widget/inputs/icon_button.dart';
import 'package:orderplus/ui/widget/inputs/labeled_text_field.dart';
import 'package:path_provider/path_provider.dart';

class AddItemModal extends StatefulWidget {
  final ProductService productService;
  final Product? initialProduct;
  const AddItemModal({
    super.key,
    required this.productService,
    this.initialProduct,
  });

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  final _formKey = GlobalKey<FormState>();

  bool isAvailable = true;
  late String selectedCategory;
  late List<String> categories = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late String? selectedImagePath;
  late int iniPorductId;
  @override
  @override
  void initState() {
    super.initState();

    categories = widget.productService
        .getAllCategoriesString()
        .where((cat) => cat != "All" && cat != "Top")
        .toList();

    if (widget.initialProduct != null) {
      final p = widget.initialProduct!;
      nameController.text = p.name;
      priceController.text = p.price.toString();
      selectedCategory = p.category.name;
      isAvailable = p.isAvailable;
      selectedImagePath = p.imageUrl;
      iniPorductId = p.id;
    } else {
      selectedCategory = categories.isNotEmpty
          ? categories.first
          : "Uncategorized";
      selectedImagePath = null;
      iniPorductId = widget.productService.getAllProducts().isEmpty
          ? 1
          : widget.productService.getAllProducts().last.id + 1;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final price = double.parse(priceController.text.trim());

    String? permanentImagePath = selectedImagePath;

    if (selectedImagePath != null &&
        !selectedImagePath!.startsWith('assets/')) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = selectedImagePath!.split('/').last;
      permanentImagePath = '${dir.path}/$fileName';
      await File(selectedImagePath!).copy(permanentImagePath);
    }

    final newProduct = Product(
      id: iniPorductId,
      name: name,
      price: price,
      category: widget.productService.getCategoryByName(selectedCategory)!,
      isAvailable: isAvailable,
      imageUrl: permanentImagePath ?? 'assets/burgur.png',
    );

    if (mounted) {
      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final labelColor = theme.textTheme.bodyMedium!.color ?? Colors.black;
    final inputFillColor = theme.colorScheme.secondary.withAlpha(
      (0.1 * 255).round(),
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 32,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState) => ImageUploadArea(
                  imagePath: selectedImagePath,
                  onImageSelected: (path) {
                    setState(() {
                      selectedImagePath = path;
                    });
                  },
                ),
              ),
              const SizedBox(height: 25),
              LabeledTextField(
                label: "Item Name",
                controller: nameController,
                hintText: "e.g. Classic Burger",
                labelColor: labelColor,
                fillColor: inputFillColor,
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter item name"
                    : null,
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: "Price",
                controller: priceController,
                hintText: "0.00",
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                labelColor: labelColor,
                fillColor: inputFillColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }
                  final price = double.tryParse(value);
                  if (price == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return CategorySelector(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (value) =>
                        setState(() => selectedCategory = value),
                    onAddCategory: (newCat) async {
                      await productService.addCategory(newCat);
                      setState(() {
                        categories.add(newCat);
                        selectedCategory = newCat;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  Switch(
                    value: isAvailable,
                    onChanged: (val) => setState(() => isAvailable = val),
                    activeThumbColor: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomIconButton(
                text: "Save Item",
                color: primaryColor,
                textColor: theme.colorScheme.onPrimary,
                onPressed: _saveItem,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
