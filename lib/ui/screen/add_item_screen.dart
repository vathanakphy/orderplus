import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/category_selector.dart';
import 'package:orderplus/ui/widget/icon_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final Color backgroundColor = const Color(0xFFF2F0E9);
  final Color primaryColor = const Color(0xFFEE7F18);
  final Color labelColor = const Color(0xFF5D4037);
  final Color inputFillColor = const Color(0xFFF8F8F8);

  bool isAvailable = true;
  List<String> categories = ["Appetizer", "Main", "Dessert"];
  String? selectedCategory = "Main";

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageUploadArea(),
            const SizedBox(height: 25),
            _buildLabel("Item Name"),
            _buildTextField(
              controller: nameController,
              hintText: "e.g. Classic Burger",
            ),
            const SizedBox(height: 20),
            _buildLabel("Price"),
            _buildTextField(
              controller: priceController,
              hintText: "0.00",
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildLabel("Category"),
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (value) {
                setState(() => selectedCategory = value);
              },
              onAddCategory: (newCat) {
                setState(() {
                  categories.add(newCat);
                  selectedCategory = newCat;
                });
              },
            ),
            // _buildLabel("Description"),
            // _buildTextField(
            //   controller: descriptionController,
            //   hintText: "Add a short description...",
            //   maxLines: 4,
            // ),

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
                ),
              ],
            ),
            const SizedBox(height: 40),
            CustomIconButton(
              text: "Save Item",
              color: primaryColor,
              textColor: Colors.white,
              onPressed: () {
                // Access controllers here: nameController.text, descriptionController.text, priceController.text
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: labelColor,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: inputFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: labelColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: labelColor, size: 20)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildImageUploadArea() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: inputFillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "Upload Image",
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
