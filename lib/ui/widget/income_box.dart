import 'package:flutter/material.dart';

class IncomeMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final bool isPositive;

  const IncomeMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Colors.white;
    const Color titleColor = Colors.black54; 
    const Color valueColor = Color(0xFF1D1B20); 
    const Color positiveColor = Colors.green; 
    const Color negativeColor = Color(0xFFD32F2F); 
    const Color borderColor = Color(0xFFEEEEEE);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),          
          Text(
            value,
            style: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 8),          
          Text(
            '${isPositive ? '+' : ''}$percentage',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isPositive ? positiveColor : negativeColor,
            ),
          ),
        ],
      ),
    );
  }
}