import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/order_payment_card.dart';
import 'package:orderplus/ui/widget/search_bar.dart';
import 'package:orderplus/ui/widget/selection_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedFilterIndex =
      1; // Default to 'Unpaid' based on screenshot focus usually

  // Sample Data matching the screenshot
  final List<Map<String, dynamic>> _allOrders = [
    {
      "orderNumber": "1024",
      "price": 24.50,
      "customerName": "John D.",
      "itemCount": 3,
      "isPaid": false,
    },
    {
      "orderNumber": "1022",
      "price": 15.75,
      "customerName": "Table 5",
      "itemCount": 2,
      "isPaid": false,
    },
    {
      "orderNumber": "1021",
      "price": 42.00,
      "customerName": "Jane S.",
      "itemCount": 5,
      "isPaid": true,
    },
  ];

  // Filter Logic
  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilterIndex == 0) return _allOrders; // All
    if (_selectedFilterIndex == 1) {
      return _allOrders.where((o) => !o['isPaid']).toList(); // Unpaid
    }
    return _allOrders.where((o) => o['isPaid']).toList(); // Paid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SearchBarComponent(
                    hintText: "Search by order # or customer",
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 20),
                  SelectionBar(
                    items: const ["All", "Unpaid", "Paid"],
                    initialIndex: _selectedFilterIndex,
                    onItemSelected: (index) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                itemCount: _filteredOrders.length,
                separatorBuilder: (ctx, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final order = _filteredOrders[index];
                  return OrderPayment(
                    orderNumber: order["orderNumber"],
                    price: order["price"],
                    customerName: order["customerName"],
                    itemCount: order["itemCount"],
                    isPaid: order["isPaid"],
                    onToggleChanged: (val) {
                      setState(() {
                        order["isPaid"] = val;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
