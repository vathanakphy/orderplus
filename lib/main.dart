import 'package:flutter/material.dart';
import 'package:orderplus/data/design_config.dart';
import 'package:orderplus/ui/screen/add_item_screen.dart';
import 'package:orderplus/ui/screen/home_screen.dart';
import 'package:orderplus/ui/screen/income_screen.dart';
import 'package:orderplus/ui/screen/menu_screen.dart';
import 'package:orderplus/ui/screen/order_queue_screen.dart';
import 'package:orderplus/ui/screen/payment_screen.dart';
import 'package:orderplus/ui/widget/screen_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderPlus',
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const ScreenWrapper(
          title: 'Dashboard',
          leftIcon: Icons.menu,
          rightIcon: Icons.settings,
          child: HomeScreen(),
        ),
        '/menu': (context) => ScreenWrapper(
          title: 'Menu',
          leftIcon: Icons.arrow_back_ios,
          onLeftIconPressed: () => Navigator.pop(context),
          rightIcon: Icons.search,
          onRightIconPressed: () => print("Search tapped"),
          child: MenuScreen(),
        ),
        '/add-item': (context) => ScreenWrapper(
          title: 'Add Item',
          leftIcon: Icons.arrow_back_ios,
          rightIcon: Icons.save,
          onRightIconPressed: () => print("Save tapped"),
          child: AddItemScreen(),
        ),
        '/income': (context) => const ScreenWrapper(
          title: 'Income',
          leftIcon: Icons.arrow_back_ios,
          child: IncomeScreen(),
        ),
        '/payment': (context) => const ScreenWrapper(
          title: 'Payment',
          leftIcon: Icons.arrow_back_ios,
          child: PaymentScreen(),
        ),
        '/order-queue': (context) => const ScreenWrapper(
          title: 'Orders Queue',
          leftIcon: Icons.arrow_back_ios,
          child: OrderQueueScreen(),
        ),
        '/add-order': (context) =>
            const Scaffold(body: Center(child: Text("Add Order Screen"))),
      },
    );
  }
}
