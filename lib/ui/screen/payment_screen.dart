import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/ui/widget/inputs/search_bar.dart';
import '../widget/cards/order_payment_card.dart';
import '../widget/layout/payment_detail.dart';
import '../widget/inputs/selection_bar.dart';

class PaymentScreen extends StatefulWidget {
  final OrderService orderService;

  const PaymentScreen({super.key, required this.orderService});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentStatus? _selectedPaymentStatus = PaymentStatus.unpaid;

  void _onFilterSelected(int index) {
    setState(() {
      _selectedPaymentStatus = switch (index) {
        0 => null, // All
        1 => PaymentStatus.unpaid,
        2 => PaymentStatus.paid,
        _ => null,
      };
    });
  }

  void _confirmPayment(Order order) {
    widget.orderService.payOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment confirmed successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {});
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentDetailSheet(
        order: order,
        onConfirmPayment: () {
          Navigator.pop(context);
          _confirmPayment(order);
        },
      ),
    );
  }

  List<Order> _filteredOrders() {
    final allOrders = widget.orderService.getAllOrders();
    if (_selectedPaymentStatus == null) return allOrders;
    return allOrders
        .where((o) => o.paymentStatus == _selectedPaymentStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders().reversed.toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payments",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomSearchBar(
                hintText: "Search by order",
                onChanged: (query) {
                  setState(() {
                    orders.where(
                      (order) => order.id.toString().contains(query),
                    );
                  });
                },
              ),

              const SizedBox(height: 20),
              SelectionBar(
                items: const ["All", "Unpaid", "Paid"],
                initialIndex: _selectedPaymentStatus == null
                    ? 0
                    : _selectedPaymentStatus == PaymentStatus.unpaid
                    ? 1
                    : 2,
                onItemSelected: _onFilterSelected,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (_, index) {
              final order = orders[index];
              return OrderPaymentCard(
                order: order,
                onTap: () => _showOrderDetails(order),
              );
            },
          ),
        ),
      ],
    );
  }
}
