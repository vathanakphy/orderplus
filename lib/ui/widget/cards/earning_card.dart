import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:orderplus/domain/service/order_service.dart';

enum EarningsMode { day, month, year }

class EarningsCard extends StatefulWidget {
  final OrderService orderService;

  const EarningsCard({super.key, required this.orderService});

  @override
  State<EarningsCard> createState() => _EarningsCardState();
}

class _EarningsCardState extends State<EarningsCard> {
  EarningsMode _mode = EarningsMode.day;
  DateTime _selectedDate = DateTime.now();

  String get title {
    switch (_mode) {
      case EarningsMode.day:
        return "Earnings Today";
      case EarningsMode.month:
        return "Earnings This Month";
      case EarningsMode.year:
        return "Earnings This Year";
    }
  }

  String get dateText {
    switch (_mode) {
      case EarningsMode.day:
        return DateFormat('dd MMM').format(_selectedDate);
      case EarningsMode.month:
        return DateFormat('MMM yyyy').format(_selectedDate);
      case EarningsMode.year:
        return DateFormat('yyyy').format(_selectedDate);
    }
  }

  double get amount {
    switch (_mode) {
      case EarningsMode.day:
        return widget.orderService.getTotalEarningsByDate(_selectedDate);
      case EarningsMode.month:
        return widget.orderService.getTotalEarningsByMonth(_selectedDate);
      case EarningsMode.year:
        return widget.orderService.getTotalEarningsByYear(_selectedDate);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    if (_mode == EarningsMode.day) {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() => _selectedDate = picked);
      }
    } else if (_mode == EarningsMode.month) {
      final picked = await showMonthPicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          _selectedDate = DateTime(picked.year, picked.month, 1);
        });
      }
    } else {
      final picked = await showYearPicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          _selectedDate = DateTime(picked);
        });
      }
    }
  }

  void _changeMode(EarningsMode mode) {
    setState(() {
      _mode = mode;
      _selectedDate = DateTime.now();
    });
  }

  Widget _modeTile(BuildContext context, EarningsMode mode, String label) {
    return ListTile(
      title: Text(label),
      trailing: _mode == mode
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        Navigator.pop(context);
        _changeMode(mode);
      },
    );
  }

  void _showModeMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Earnings Mode"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _modeTile(context, EarningsMode.day, "Daily Earnings"),
              _modeTile(context, EarningsMode.month, "Monthly Earnings"),
              _modeTile(context, EarningsMode.year, "Yearly Earnings"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MODE
              GestureDetector(
                onTap: () => _showModeMenu(context),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  ],
                ),
              ),

              // DATE
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Row(
                  children: [
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
