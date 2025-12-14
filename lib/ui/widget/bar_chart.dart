import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: BarChartComponent(),
          ),
        ),
      ),
    ),
  );
}

class BarData {
  final String day;
  final double value; // Only double input
  BarData(this.day, this.value);
}

class BarChartComponent extends StatefulWidget {
  const BarChartComponent({super.key});

  @override
  State<BarChartComponent> createState() => _BarChartComponentState();
}

class _BarChartComponentState extends State<BarChartComponent> {
  final List<BarData> data = [
    BarData("Mon", 540),
    BarData("Tue", 300),
    BarData("Wed", 420),
    BarData("Thu", 600),
    BarData("Fri", 1020),
    BarData("Sat", 780),
    BarData("Sun", 840),
  ];

  int _selectedIndex = 4;

  // Auto format price
  String formatPrice(double v) {
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color barInactive = Color(0xFFFFE0B2);
    const Color barActive = Color(0xFFEF6C00);
    const Color textActive = Color(0xFF1D1B20);
    const Color textInactive = Color(0xFF9E9E9E);
    const Color tooltipColor = Color(0xFF212121);

    final double maxValue = data
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Revenue Overview",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "\$1,204.50",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "+5.4%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Chart
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Loop through data
                for (int index = 0; index < data.length; index++) ...[
                  // 1. The Bar Item (Wrapped in Expanded to fill width)
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final BarData item = data[index];
                        final bool isSelected = index == _selectedIndex;
                        // Calculate height relative to max value (max height 160)
                        final double barHeight = (item.value / maxValue) * 160;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          behavior: HitTestBehavior.opaque,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              // Tooltip - free floating above bar
                              if (isSelected)
                                Positioned(
                                  top: -40,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tooltipColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          formatPrice(item.value),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Column with bar + day
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Bar
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutBack,
                                    width: double.infinity,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? barActive
                                          : barInactive,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Day label
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? textActive
                                          : textInactive,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                    child: Text(item.day),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (index < data.length - 1)
                    const SizedBox(width: 8), //ENsure Gap is 4 px
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
