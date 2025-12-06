import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/acitvity_card.dart';
import 'package:orderplus/ui/widget/icon_button.dart';
import 'package:orderplus/ui/widget/infor_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //need padding
      body: ListView(
        children: [
          SizedBox(height: 20),
          InfoCard(
            color: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Total Orders Today",
            value: 24.toString(),
            icon: Icons.receipt_long_outlined,
          ),
          SizedBox(height: 5),
          InfoCard(
            color: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Pedding",
            value: 24.toString(),
            icon: Icons.pending_actions_sharp,
          ),
          SizedBox(height: 5),
          InfoCard(
            color: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Unpaid",
            value: 24.toString(),
            icon: Icons.attach_money_rounded,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Actions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          CustomIconButton(
            color: Theme.of(context).colorScheme.primary,
            iconColor: Colors.white,
            text: "Add New Order",
            icon: Icons.add_circle_outline_outlined,
            textColor: Colors.white,
            height: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/add-order');
            },
          ),
          SizedBox(height: 10),
          CustomIconButton(
            color: Theme.of(context).colorScheme.secondary,
            iconColor: Colors.black,
            text: "View Order Queue",
            icon: Icons.list_alt_sharp,
            textColor: Colors.black,
            height: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/order-queue');
            },
          ),
          SizedBox(height: 10),
          CustomIconButton(
            color: Theme.of(context).colorScheme.secondary,
            iconColor: Colors.black,
            text: "Payment",
            icon: Icons.payments_outlined,
            textColor: Colors.black,
            height: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/payment');
            },
          ),
          SizedBox(height: 10),
          CustomIconButton(
            color: Theme.of(context).colorScheme.secondary,
            iconColor: Colors.black,
            text: "Manage Menu",
            icon: Icons.restaurant_menu,
            textColor: Colors.black,
            height: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          SizedBox(height: 10),
          CustomIconButton(
            color: Theme.of(context).colorScheme.secondary,
            iconColor: Colors.black,
            text: "Income",
            icon: Icons.monetization_on_outlined,
            textColor: Colors.black,
            height: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/income');
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Activity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          ActivityCard(
            color: Theme.of(context).colorScheme.onSecondary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Order #1111 Completed",
            value: "2 mins ago",
            icon: Icons.add_task,
          ),
          ActivityCard(
            color: Theme.of(context).colorScheme.onSecondary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Order #1111 Completed",
            value: "3 mins ago",
            icon: Icons.add_task,
          ),
          ActivityCard(
            color: Theme.of(context).colorScheme.onSecondary,
            iconColor: Theme.of(context).colorScheme.primary,
            title: "Order #1111 Completed",
            value: "4 mins ago",
            icon: Icons.add_task,
          ),
        ],
      ),
    );
  }
}
