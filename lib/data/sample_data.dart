import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/product.dart';

// --------------------
// Seed Products
// --------------------
void seedProducts(ProductRepository repo) {
  const img = 'assets/burgur.png';

  final products = <Product>[
    Product(name: 'Classic Burger', description: 'Beef patty, lettuce, tomato, cheese, and sauce.', price: 3.99, imageUrl: img, category: 'Burger'),
    Product(name: 'Cheese Lover', description: 'Extra cheese with beef patty and fresh veggies.', price: 4.49, imageUrl: img, category: 'Burger'),
    Product(name: 'Margherita Pizza', description: 'Classic tomato, mozzarella, and basil.', price: 6.99, imageUrl: img, category: 'Pizza'),
    Product(name: 'Pepperoni Pizza', description: 'Pepperoni, cheese, and tomato sauce.', price: 7.49, imageUrl: img, category: 'Pizza'),
    Product(name: 'Veggie Delight', description: 'Bell peppers, olives, onions, and mushrooms.', price: 6.79, imageUrl: img, category: 'Pizza'),
    Product(name: 'Cola Drink', description: 'Refreshing carbonated cola.', price: 1.99, imageUrl: img, category: 'Drinks'),
    Product(name: 'Lemonade', description: 'Freshly squeezed lemon juice with sugar.', price: 2.49, imageUrl: img, category: 'Drinks'),
    Product(name: 'Iced Tea', description: 'Cool and refreshing iced tea.', price: 2.29, imageUrl: img, category: 'Drinks'),
    Product(name: 'Chocolate Cake', description: 'Rich chocolate cake with cream frosting.', price: 3.99, imageUrl: img, category: 'Dessert'),
    Product(name: 'Ice Cream Sundae', description: 'Vanilla ice cream with chocolate sauce and cherry.', price: 4.49, imageUrl: img, category: 'Dessert'),
  ];

  for (final p in products) {
    repo.add(p);
    repo.addCategory(p.category);
  }
}

// --------------------
// Seed Orders
// --------------------
void seedOrders(OrderRepository repo, List<Product> products) {
  // Add available tables to the system
  repo.addTables([1, 2, 3, 4, 5]);

  // Prevent crashing if product list is empty
  if (products.isEmpty) return;

  final order1 = Order(id: 1,tableNumber: 1)
    ..addItem(products.firstWhere((p) => p.name == 'Classic Burger'), 2)
    ..addItem(products.firstWhere((p) => p.name == 'Cola Drink'), 2);

  final order2 = Order(id: 2,tableNumber: 2)
    ..addItem(products.firstWhere((p) => p.name == 'Margherita Pizza'), 1)
    ..addItem(products.firstWhere((p) => p.name == 'Lemonade'), 1);

  final order3 = Order(id: 3,tableNumber: 3)
    ..addItem(products.firstWhere((p) => p.name == 'Pepperoni Pizza'), 1)
    ..addItem(products.firstWhere((p) => p.name == 'Iced Tea'), 2)
    ..markPaid()
    ..markServed();

  // Add orders to repository
  repo.addOrder(order1);
  repo.addOrder(order2);
  repo.addOrder(order3);
}