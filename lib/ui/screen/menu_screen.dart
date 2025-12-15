import 'package:flutter/material.dart';
import 'package:orderplus/ui/screen/add_item_screen.dart';
import 'package:orderplus/ui/widget/product_infor.dart';
import 'package:orderplus/ui/widget/search_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SearchBarComponent(
              hintText: "Search for a menu item...",
              onChanged: (value) {},
            ),
            const SizedBox(height: 25),
            _buildSectionHeader("Mains"),
            ProductInfoTile(
              title: "Classic Cheeseburger",
              price: 12.99,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 12),
            ProductInfoTile(
              title: "Margherita Pizza",
              price: 15.50,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 25),
            _buildSectionHeader("Appetizers"),
            ProductInfoTile(
              title: "Onion Rings",
              price: 8.50,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 25),
            _buildSectionHeader("Desserts"),
            ProductInfoTile(
              title: "Chocolate Lava Cake",
              price: 9.75,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            ProductInfoTile(
              title: "Chocolate Lava Cake",
              price: 9.75,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            ProductInfoTile(
              title: "Chocolate Lava Cake",
              price: 9.75,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            ProductInfoTile(
              title: "Chocolate Lava Cake",
              price: 9.75,
              imageUrl: "assets/burgur.png",
              onEdit: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.95,
              minChildSize: 0.5,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AddItemScreen(),
                    ),
                  ),
                );
              },
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }
}
