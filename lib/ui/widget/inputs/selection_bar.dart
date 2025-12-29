import 'package:flutter/material.dart';

class SelectionBar extends StatefulWidget {
  final List<String> items;
  final ValueChanged<int>? onItemSelected;
  final int initialIndex;

  const SelectionBar({
    super.key,
    required this.items,
    this.onItemSelected,
    this.initialIndex = 0,
  });

  @override
  State<SelectionBar> createState() => _SelectionBarState();
}

class _SelectionBarState extends State<SelectionBar> {
  late int _selectedIndex;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    const Color barBackground = Color(0xFFF4EFE9);
    const Color selectedBg = Colors.white;
    const Color selectedText = Color(0xFF1D1B20);
    const Color unselectedText = Color(0xFF9E9E9E);
    const double barHeight = 40;

    return SizedBox(
      height: barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // compute individual widths
          final itemWidths = widget.items.map((t) {
            final tp = TextPainter(
              text: TextSpan(
                text: t,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              textDirection: TextDirection.ltr,
            )..layout();
            return tp.width + 32;
          }).toList();

          // If all items fit → spread equally
          final totalWidth = itemWidths.fold(0.0, (a, b) => a + b);
          final useScroll = totalWidth > constraints.maxWidth;

          final fixedWidth =
              useScroll ? null : constraints.maxWidth / widget.items.length;

          // calculate selected item offset (for background)
          double offsetX = 0;
          for (int i = 0; i < _selectedIndex; i++) {
            offsetX += fixedWidth ?? itemWidths[i];
          }
          final selectedWidth = fixedWidth ?? itemWidths[_selectedIndex];

          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: barBackground,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                // --- Moving background ---
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  left: offsetX,
                  top: 0,
                  bottom: 0,
                  width: selectedWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedBg,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  controller: _scroll,
                  scrollDirection: Axis.horizontal,
                  physics: useScroll
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: List.generate(widget.items.length, (index) {
                      final isSelected = index == _selectedIndex;

                      return SizedBox(
                        width: fixedWidth ?? itemWidths[index],
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            setState(() => _selectedIndex = index);
                            widget.onItemSelected?.call(index);
                          },
                          child: Center(
                            child: Text(
                              widget.items[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected ? selectedText : unselectedText,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
