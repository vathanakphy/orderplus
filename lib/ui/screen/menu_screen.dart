import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/product_infor.dart';
import 'package:orderplus/ui/widget/search_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SearchBarComponent(
              hintText: "Search for a menu item...",
              onChanged: (value) {
              },
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
            const SizedBox(height: 80), 
          ],
        ),
      ),
      
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {
            // Handle Add New Item
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
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