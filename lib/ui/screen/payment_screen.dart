import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/utils/flexible_image.dart';
import 'package:orderplus/ui/widget/inputs/delete_alert.dart';
import 'package:orderplus/ui/widget/inputs/search_app_bar.dart';
import '../widget/cards/order_payment_card.dart';
import '../widget/cards/order_detail.dart';
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

    setState(() {});
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderDetails(
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
      isASC: false,
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  if (!order.isPaid && !order.isCancelled) {
                    final result = await showDeleteDialog(
                      context: context,
                      confirmText: "Confirm",
                      title: "Cancel Order",
                      cancelText: "Cancel",
                      content:
                          "Are you sure you want to Cancel Order #${order.id}?",
                    );
                    return result;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cannot be canceled.")),
                    );
                    return false;
                  }
                },
                onDismissed: (direction) async {
                  setState(() {
                    orders.removeAt(index);
                  });
                  await widget.orderService.cancelOrder(order);
                },
                key: Key(order.id.toString()),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: OrderPaymentCard(
                    order: order,
                    onTap: () => _showOrderDetails(order),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
