import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/utils/flexible_image.dart';
import 'package:orderplus/ui/widget/inputs/search_app_bar.dart';
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
  String _searchQuery = "";

  void _confirmPayment(Order order) {
    widget.orderService.payOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment confirmed successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
    });
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

  @override
  Widget build(BuildContext context) {
    final orders = widget.orderService.filterOrders(
      paymentStatus: _selectedPaymentStatus,
      idQuery: _searchQuery,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAppBar(
                titleWidget: SizedBox(
                  width: 150,
                  height: 40,
                  child: flexibleImage(
                    "assets/app_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
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
                onItemSelected: (index) {
                  setState(() {
                    _selectedPaymentStatus = switch (index) {
                      0 => null,
                      1 => PaymentStatus.unpaid,
                      2 => PaymentStatus.paid,
                      _ => null,
                    };
                  });
                },
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
