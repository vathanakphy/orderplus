import 'package:flutter/material.dart';
import 'package:orderplus/data/design_config.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/screen/table_screen.dart';
import 'package:orderplus/ui/screen/menu_screen.dart';
import 'package:orderplus/ui/screen/payment_screen.dart';
import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/data/sample_data.dart';

late final OrderService orderService;
late final ProductService productService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final orderRepo = OrderRepository();
  final productRepo = ProductRepository();

  await orderRepo.clearData();
  await productRepo.clearData();

  await seedProducts(productRepo);
  final products = productRepo.getAll();
  await seedOrders(orderRepo, products);
  productService = ProductService(productRepo);
  orderService = OrderService(repository: orderRepo);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderPlus',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: MainScreenWrapper(
        orderService: orderService,
        productService: productService,
      ),
    );
  }
}

class MainScreenWrapper extends StatefulWidget {
  final OrderService orderService;
  final ProductService productService;

  const MainScreenWrapper({
    super.key,
    required this.orderService,
    required this.productService,
  });

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TableScreen(
        orderService: widget.orderService,
        productService: widget.productService,
      ),
      MenuScreen(productService: widget.productService),
      PaymentScreen(orderService: widget.orderService),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant),
            label: 'Tables',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Payments',
          ),
        ],
      ),
    );
  }
}
