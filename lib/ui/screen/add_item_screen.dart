import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/product.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/inputs/image_upload_area.dart';
import 'package:orderplus/ui/widget/inputs/category_selector.dart';
import 'package:orderplus/ui/widget/inputs/icon_button.dart';
import 'package:orderplus/ui/widget/inputs/labeled_text_field.dart';

class AddItemScreen extends StatefulWidget {
  final ProductService productService;
  const AddItemScreen({super.key, required this.productService});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isAvailable = true;
  late String selectedCategory;
  late List<String> categories = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    categories = widget.productService.getAllCategories().where((cat) => cat != "All").toList();
    selectedCategory = categories.first;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final price = double.tryParse(priceController.text.trim()) ?? 0.0;
      final category = selectedCategory;
      final newProduct = Product(
        name: name,
        description: descriptionController.text.trim(),
        price: price,
        category: category,
        isAvailable: isAvailable,
        imageUrl: 'assets/burgur.png',
      );
      widget.productService.addProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.cancel_outlined,
                size: 32,
                color: theme.colorScheme.error,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            ImageUploadArea(fillColor: inputFillColor),
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
                if (value == null || value.isEmpty) return "Please enter price";
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
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (value) =>
                  setState(() => selectedCategory = value),
              onAddCategory: (newCat) {
                setState(() {
                  categories.add(newCat);
                  selectedCategory = newCat;
                });
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
          ],
        ),
      ),
    );
  }
}
