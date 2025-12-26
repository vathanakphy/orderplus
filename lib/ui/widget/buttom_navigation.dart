import 'package:flutter/material.dart';
import 'package:orderplus/ui/screen/table_screen.dart';
import 'package:orderplus/ui/screen/menu_screen.dart';
import 'package:orderplus/ui/screen/order_queue_screen.dart';
import 'package:orderplus/ui/screen/payment_screen.dart';
import 'package:orderplus/ui/widget/screen_wrapper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TableScreen(),
    const MenuScreen(),
    const OrderQueueScreen(),
    const PaymentScreen(),
  ];

  final List<String> _titles = ['Tables', 'Menu', 'Queue', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        title: _titles[_currentIndex],
        leftIcon: null,
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.orange, // Orange background
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Use container color
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Tables',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Queue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Payment',
            ),
          ],
        ),
      ),
    );
  }
}
