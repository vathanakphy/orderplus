import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/product.dart';

void seedSampleProducts(ProductRepository repo) {
  // Use a single image reference for all products
  const img = 'assets/burgur.png';

  final products = <Product>[
    // Burger category
    Product(
      name: 'Classic Burger',
      description: 'Beef patty, lettuce, tomato, cheese, and sauce.',
      price: 3.99,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Cheese Lover',
      description: 'Extra cheese with beef patty and fresh veggies.',
      price: 4.49,
      imageUrl: img,
      category: 'Burger',
    ),
    // Pizza category
    Product(
      name: 'Margherita Pizza',
      description: 'Classic tomato, mozzarella, and basil.',
      price: 6.99,
      imageUrl: img,
      category: 'Pizza',
    ),
    Product(
      name: 'Pepperoni Pizza',
      description: 'Pepperoni, cheese, and tomato sauce.',
      price: 7.49,
      imageUrl: img,
      category: 'Pizza',
    ),
    Product(
      name: 'Veggie Delight',
      description: 'Bell peppers, olives, onions, and mushrooms.',
      price: 6.79,
      imageUrl: img,
      category: 'Pizza',
    ),
    // Drinks category
    Product(
      name: 'Cola Drink',
      description: 'Refreshing carbonated cola.',
      price: 1.99,
      imageUrl: img,
      category: 'Drinks',
    ),
    Product(
      name: 'Lemonade',
      description: 'Freshly squeezed lemon juice with sugar.',
      price: 2.49,
      imageUrl: img,
      category: 'Drinks',
    ),
    Product(
      name: 'Iced Tea',
      description: 'Cool and refreshing iced tea.',
      price: 2.29,
      imageUrl: img,
      category: 'Drinks',
    ),
    // Dessert category
    Product(
      name: 'Chocolate Cake',
      description: 'Rich chocolate cake with cream frosting.',
      price: 3.99,
      imageUrl: img,
      category: 'Dessert',
    ),
    Product(
      name: 'Ice Cream Sundae',
      description: 'Vanilla ice cream with chocolate sauce and cherry.',
      price: 4.49,
      imageUrl: img,
      category: 'Dessert',
    ),
  ];

  for (final p in products) {
    repo.add(p);
    repo.addCategory(p.category);
  }
}
