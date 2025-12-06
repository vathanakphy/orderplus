import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/bar_chart.dart';
import 'package:orderplus/ui/widget/income_box.dart';
import 'package:orderplus/ui/widget/order_pay_alert.dart';
import 'package:orderplus/ui/widget/selection_bar.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  int _selectedPeriodIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: SelectionBar(
                          items: const ["Daily", "Weekly", "Monthly", "Yearly"],
                          initialIndex: _selectedPeriodIndex,
                          onItemSelected: (index) {
                            setState(() => _selectedPeriodIndex = index);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: IncomeMetricCard(
                            title: "Total Revenue",
                            value: "\$1,204.50",
                            percentage: "5.4%",
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IncomeMetricCard(
                            title: "Profit",
                            value: "\$843.15",
                            percentage: "3.1%",
                            isPositive: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: IncomeMetricCard(
                            title: "Orders",
                            value: "86",
                            percentage: "8.2%",
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IncomeMetricCard(
                            title: "Avg. Order",
                            value: "\$14.01",
                            percentage: "1.2%",
                            isPositive: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const BarChartComponent(),
                    const SizedBox(height: 25),
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    OrderPaymentAlert(
                      orderNumber: "#58923",
                      time: "10:42 AM",
                      price: 24.50,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    OrderPaymentAlert(
                      orderNumber: "#58922",
                      time: "10:31 AM",
                      price: 12.00,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    OrderPaymentAlert(
                      orderNumber: "#58921",
                      time: "10:25 AM",
                      price: 35.75,
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}