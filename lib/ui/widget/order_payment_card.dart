import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/switch_button.dart';


class OrderPayment extends StatefulWidget {
  final String orderNumber;
  final double price;
  final String customerName;
  final int itemCount;
  final bool isPaid;
  final ValueChanged<bool>? onToggleChanged;

  const OrderPayment({
    super.key,
    required this.orderNumber,
    required this.price,
    required this.customerName,
    required this.itemCount,
    this.isPaid = false,
    this.onToggleChanged,
  });

  @override
  State<OrderPayment> createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  late bool _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.isPaid;
  }

  Future<void> _onSwitchChanged(bool val) async {
    // If the order is already paid and user tries to toggle
    if (_switchValue && val != _switchValue) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Confirm Change"),
          content: const Text(
            "This order is already marked as Paid. Do you want to change it?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Yes"),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    setState(() => _switchValue = val);

    if (widget.onToggleChanged != null) {
      widget.onToggleChanged!(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Colors.white;
    const Color iconBg = Color(0xFFF4EFE9);
    const Color iconColor = Color(0xFF5D4037);
    const Color titleColor = Color(0xFF1D1B20);
    const Color priceColor = Color(0xFF8D6E63);
    const Color activeSwitch = Color(0xFFE86A12);

    final Color badgeBg = _switchValue
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF3E0);
    final Color badgeText = _switchValue
        ? const Color(0xFF2E7D32)
        : const Color(0xFFEF6C00);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: _switchValue
            ? Border.all(color: activeSwitch, width: 1)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: iconColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${widget.orderNumber}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${widget.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.customerName} - ${widget.itemCount} items",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA1887F),
                  ),
                ),
              ],
            ),
          ),
          // Badge & Switch
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: badgeText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _switchValue ? "Paid" : "Unpaid",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: badgeText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SwitchButton(value: _switchValue, onChanged: _onSwitchChanged),
            ],
          ),
        ],
      ),
    );
  }
}
