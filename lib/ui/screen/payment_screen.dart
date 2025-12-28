import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/service/order_service.dart';
import '../widget/order_payment_card.dart';
import '../widget/payment_detail.dart';
import '../widget/search_bar.dart';
import '../widget/selection_bar.dart';
class PaymentScreen extends StatefulWidget {
  final OrderService orderService;

  const PaymentScreen({super.key, required this.orderService});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentStatus? _selectedPaymentStatus = PaymentStatus.unpaid;
  late List<Order> _orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _orders = _filteredOrders();
  }

  List<Order> _filteredOrders() {
    if (_selectedPaymentStatus == null) return widget.orderService.getAllOrders();
    return widget.orderService.getOrdersByPaymentStatus(_selectedPaymentStatus!);
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedPaymentStatus = switch (index) {
        0 => null,
        1 => PaymentStatus.unpaid,
        _ => PaymentStatus.paid,
      };
      _loadOrders();
    });
  }

  void _confirmPayment(Order order) {
    setState(() {
      widget.orderService.payOrder(order);
      _orders.remove(order); // remove immediately
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment confirmed successfully!"),
        backgroundColor: Colors.green,
      ),
    );
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SearchBarComponent(hintText: "Search by order # or customer"),
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
            itemCount: _orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (_, index) {
              final order = _orders[index];
              return OrderPaymentCard(
                orderNumber: order.tableNumber?.toString() ?? "Pickup Customer",
                price: order.totalAmount,
                customerName: order.tableNumber != null
                    ? "Table ${order.tableNumber}"
                    : "Pickup Customer",
                itemCount: order.items.length,
                isPaid: order.isPaid,
                onTap: () => _showOrderDetails(order),
              );
            },
          ),
        ),
      ],
    );
  }
}
