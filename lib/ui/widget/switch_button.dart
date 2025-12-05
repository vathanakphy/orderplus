import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  static const double _height = 40;
  static const double _scale = 1;

  const SwitchButton({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Transform.scale(
        scale: _scale,
        alignment: Alignment.centerRight,
        child: Switch(
          value: value,
          activeTrackColor: const Color(0xFFE86A12),
          inactiveTrackColor: const Color(0xFFEEEEEE),
          inactiveThumbColor: Colors.white,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
