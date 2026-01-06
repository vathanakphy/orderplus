import 'package:flutter_test/flutter_test.dart';
import 'package:orderplus/data/sample_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orderplus/data/app_database.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ProductRepository productRepo;
  late OrderRepository orderRepo;
  late OrderService orderService;
  late ProductService productService;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Open a single in-memory DB for all tests
    db = await AppDatabase(dbPath: inMemoryDatabasePath).open();

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Init repositories
    productRepo = ProductRepository(database: db);
    orderRepo = OrderRepository(
      database: db,
      productsRepository: productRepo,
      prefs: prefs,
    );

    // Seed database
    await seedAllData(productRepo, orderRepo);

    // Init services
    orderService = OrderService(repository: orderRepo);
    productService = ProductService(productRepo);
  });

  tearDownAll(() async {
    await db.close();
  });


  // OrderService

  test('Add to cart increases quantity if product exists', () {
    final product = productRepo.getAll().first;
    orderService.addToCart(1, product);
    orderService.addToCart(1, product);
    expect(orderService.getCartItems().first.quantity, 2);
  });

  test('Place order adds new order when no active order exists', () async {
    final product = productRepo.getAll().first;
    final result = await orderService.placeOrder(
      tableId: 5,
      items: [
        OrderItem(product: product, quantity: 1, priceAtOrder: product.price),
      ],
    );
    expect(result, true);
    expect(orderService.getAllOrders().any((o) => o.tableNumber == 5), true);
  });

  test('Place order merges items into existing order', () async {
    final product = productService.getAllProducts()[0]; 
    final existingOrder = orderService.getCurrentOrdersByTable(1);
    final initialQty = existingOrder!.items.first.quantity;

    await orderService.placeOrder(
      tableId: 1,
      items: [
        OrderItem(product: product, quantity: 3, priceAtOrder: product.price),
      ],
    );
    expect(existingOrder.items.first.quantity, initialQty + 3);
  });

  test('Cancel order updates repository', () async {
    final order = orderService.getAllOrders()[0];
    await orderService.cancelOrder(order);
    expect(order.isCancelled, true);
  });

  test('Pay order updates payment status', () async {
    final order = orderService.getAllOrders()[1];
    await orderService.payOrder(order);
    expect(order.paymentStatus, PaymentStatus.paid);
  });

  test('Get total earnings by date sums paid orders only', () {
    final order = orderService.getAllOrders();
    final total = orderService.getTotalEarningsByDate(order[2].createdAt);
    expect(total, order[1].totalAmount); 
  });

  test('Clear cart empties cart items', () {
    final product = productRepo.getAll().first;
    orderService.addToCart(1, product);
    orderService.clearCart();
    expect(orderService.getCartItems(), isEmpty);
  });

}
