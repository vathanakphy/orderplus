import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/providers.dart';
import 'package:orderplus/ui/widget/order_payment_card.dart';
import 'package:orderplus/ui/widget/payment_detail.dart';
import 'package:orderplus/ui/widget/search_bar.dart';
import 'package:orderplus/ui/widget/selection_bar.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentStatus? _selectedPaymentStatus = PaymentStatus.unpaid;

  List<Order> _filteredOrders(OrderService service) {
    if (_selectedPaymentStatus == null) {
      return service.getAllOrders();
    }
    return service.getOrdersByPaymentStatus(_selectedPaymentStatus!);
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedPaymentStatus = switch (index) {
        0 => null,
        1 => PaymentStatus.unpaid,
        _ => PaymentStatus.paid,
      };
    });
  }

  void _showOrderDetails(Order order, OrderService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentDetailSheet(
        order: order,
        onConfirmPayment: () {
          service.payOrder(order);
          ref.invalidate(orderServiceProvider);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment confirmed successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderService = ref.watch(orderServiceProvider);
    final orders = _filteredOrders(orderService);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SearchBarComponent(
                hintText: "Search by order # or customer",
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
                orderNumber: order.tableNumber?.toString() ?? "N/A",
                price: order.totalAmount,
                customerName: order.tableNumber != null
                    ? "Table ${order.tableNumber}"
                    : "Customer",
                itemCount: order.items.length,
                isPaid: order.isPaid,
                onTap: () => _showOrderDetails(order, orderService),
              );
            },
          ),
        ),
      ],
    );
  }
}
