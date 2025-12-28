import 'package:flutter/material.dart';
import 'package:orderplus/data/design_config.dart';
import 'package:orderplus/data/instances.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/screen/table_screen.dart';
import 'package:orderplus/ui/screen/menu_screen.dart';
import 'package:orderplus/ui/screen/order_queue_screen.dart';
import 'package:orderplus/ui/screen/payment_screen.dart';

void main() {
  initializeData(); 
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
      TableScreen(orderService: widget.orderService,productService: widget.productService,),
      MenuScreen(productService: widget.productService),
      OrderQueueScreen(orderService: widget.orderService),
      PaymentScreen(orderService: widget.orderService),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.table_restaurant), label: 'Tables'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.queue), label: 'Queue'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Payments'),
        ],
      ),
    );
  }
}
