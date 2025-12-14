import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/product.dart';

void seedSampleProducts(ProductRepository repo) {
  // Use a single image reference for all products
  const img = 'assets/burgur.png';

  final products = <Product>[
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
    Product(
      name: 'Spicy Fire',
      description: 'Jalapeños, spicy mayo, and pepper jack cheese.',
      price: 4.79,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'BBQ Deluxe',
      description: 'Smoky BBQ sauce, crispy onions, and cheddar.',
      price: 4.99,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Mushroom Swiss',
      description: 'Sautéed mushrooms with Swiss cheese and aioli.',
      price: 5.29,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Double Stack',
      description: 'Two patties, double cheese, and special sauce.',
      price: 5.99,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Veggie Crunch',
      description: 'Grilled veggie patty with fresh greens.',
      price: 4.29,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Bacon Supreme',
      description: 'Crispy bacon, cheddar, and smoky sauce.',
      price: 5.49,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Hawaiian Twist',
      description: 'Grilled pineapple, teriyaki glaze, and lettuce.',
      price: 4.89,
      imageUrl: img,
      category: 'Burger',
    ),
    Product(
      name: 'Garlic Butter',
      description: 'Garlic butter glaze with parmesan sprinkle.',
      price: 4.69,
      imageUrl: img,
      category: 'Burger',
    ),
  ];

  for (final p in products) {
    repo.add(p);
    repo.addCategory(p.category);
  }
}
