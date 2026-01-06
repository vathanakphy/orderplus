import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/category.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/product.dart';

// --------------------
// Seed Products
// --------------------
Future<void> seedProducts(ProductRepository repo) async {
  const img = 'assets/burgur.png';

  // Define categories first
  final categoryNames = ['Burger', 'Pizza', 'Drinks', 'Dessert'];

  // Ensure categories exist in DB
  final categoryMap = <String, Category>{};
  for (final name in categoryNames) {
    await repo.addCategory(name);
    categoryMap[name] = repo.getCategoryByName(name)!;
  }

  // Define products with category objects
  final products = <Product>[
    Product(
      id: 1,
      name: 'Classic Burger',
      price: 3.99,
      imageUrl: img,
      category: categoryMap['Burger']!,
    ),
    Product(
      id: 2,
      name: 'Cheese Lover',
      price: 4.49,
      imageUrl: img,
      category: categoryMap['Burger']!,
    ),
    Product(
      id: 3,
      name: 'Margherita Pizza',
      price: 6.99,
      imageUrl: img,
      category: categoryMap['Pizza']!,
    ),
    Product(
      id: 4,
      name: 'Pepperoni Pizza',
      price: 7.49,
      imageUrl: img,
      category: categoryMap['Pizza']!,
    ),
    Product(
      id: 5,
      name: 'Veggie Delight',
      price: 6.79,
      imageUrl: img,
      category: categoryMap['Pizza']!,
    ),
    Product(
      id: 6,
      name: 'Cola Drink',
      price: 1.99,
      imageUrl: img,
      category: categoryMap['Drinks']!,
    ),
    Product(
      id: 7,
      name: 'Lemonade',
      price: 2.49,
      imageUrl: img,
      category: categoryMap['Drinks']!,
    ),
    Product(
      id: 8,
      name: 'Iced Tea',
      price: 2.29,
      imageUrl: img,
      category: categoryMap['Drinks']!,
    ),
    Product(
      id: 9,
      name: 'Chocolate Cake',
      price: 3.99,
      imageUrl: img,
      category: categoryMap['Dessert']!,
    ),
    Product(
      id: 10,
      name: 'Ice Cream Sundae',
      price: 4.49,
      imageUrl: img,
      category: categoryMap['Dessert']!,
    ),
  ];
  // Insert products
  for (final p in products) {
    await repo.add(p);
  }
}

// --------------------
// Seed Orders
// --------------------
Future<void> seedOrders(OrderRepository repo, List<Product> products) async {
  await repo.addTables([1, 2, 3, 4, 5]);

  if (products.isEmpty) return;

  // --------------------
  // Direct access by index (products list order is controlled)
  // --------------------

  // Order 1
  final order1 = Order(id: 1, tableNumber: 1);
  order1.addItem(products[0], 2); // Classic Burger (index 0)
  order1.addItem(products[5], 2); // Cola Drink (index 5)

  // Order 2
  final order2 = Order(id: 2, tableNumber: 2);
  order2.addItem(products[2], 1); // Margherita Pizza (index 2)
  order2.addItem(products[6], 1); // Lemonade (index 6)

  // Order 3
  final order3 = Order(id: 3, tableNumber: 3);
  order3.addItem(products[3], 1); // Pepperoni Pizza (index 3)
  order3.addItem(products[7], 2); // Iced Tea (index 7)

  // Add orders to repository
  repo.addOrder(order1);
  repo.addOrder(order2);
  repo.addOrder(order3);
  repo.usedTables.addAll([1, 2]);
}

// --------------------
// Seed All Data
// --------------------
Future<void> seedAllData(
  ProductRepository productRepo,
  OrderRepository orderRepo,
) async {
  await seedProducts(productRepo);

  // Access products by index after seeding
  final allProducts = productRepo.getAll();
  await seedOrders(orderRepo, allProducts);
}
