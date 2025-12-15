import 'package:flutter/material.dart';
import 'package:orderplus/app_dependencies.dart';
import 'package:orderplus/domain/model/enum.dart';
import 'package:orderplus/domain/model/order.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/ui/widget/order_payment_card.dart';
import 'package:orderplus/ui/widget/payment_detail.dart';
import 'package:orderplus/ui/widget/search_bar.dart';
import 'package:orderplus/ui/widget/selection_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  /// null = All
  /// PaymentStatus.unpaid = Unpaid
  /// PaymentStatus.paid = Paid
  PaymentStatus? _selectedPaymentStatus = PaymentStatus.unpaid;

  OrderService get _orderService => AppDependencies.of(context).orderService;

  List<Order> get _filteredOrders {
    if (_selectedPaymentStatus == null) {
      return _orderService.getAllOrders();
    }
    return _orderService.getOrdersByPaymentStatus(_selectedPaymentStatus!);
  }

  int get _selectedIndex {
    if (_selectedPaymentStatus == null) return 0;
    if (_selectedPaymentStatus == PaymentStatus.unpaid) return 1;
    return 2;
  }

  void _onFilterSelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedPaymentStatus = null; // All
          break;
        case 1:
          _selectedPaymentStatus = PaymentStatus.unpaid;
          break;
        case 2:
          _selectedPaymentStatus = PaymentStatus.paid;
          break;
      }
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
          setState(() {
            _orderService.payOrder(order);
          });

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Payment confirmed successfully!",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    return OrderPaymentCard(
      orderNumber: order.tableNumber?.toString() ?? "N/A",
      price: order.totalAmount,
      customerName: order.tableNumber != null
          ? "Table ${order.tableNumber}"
          : "Customer",
      itemCount: order.items.length,
      isPaid: order.isPaid,
      onTap: () => _showOrderDetails(order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (_, index) =>
                    _buildOrderItem(_filteredOrders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SearchBarComponent(hintText: "Search by order # or customer"),
          const SizedBox(height: 20),
          SelectionBar(
            items: const ["All", "Unpaid", "Paid"],
            initialIndex: _selectedIndex,
            onItemSelected: _onFilterSelected,
          ),
        ],
      ),
    );
  }
}
