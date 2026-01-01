
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onAddCategory;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddCategory,
  });

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newCategory = controller.text.trim();
              if (newCategory.isNotEmpty) {
                onAddCategory(newCategory);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedCategory,
            hint: const Text('Select category'),
            items: categories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onCategorySelected(value);
            },
          ),
        ),
        IconButton(
          onPressed: () => _showAddCategoryDialog(context),
          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
