import 'package:flutter/material.dart';
import 'package:orderplus/ui/widget/header_row.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData? leftIcon;
  final VoidCallback? onLeftIconPressed;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;

  const ScreenWrapper({
    super.key,
    required this.child,
    required this.title,
    this.leftIcon,
    this.onLeftIconPressed,
    this.rightIcon,
    this.onRightIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderRow(
              leftIcon: leftIcon ?? Icons.arrow_back_ios,
              title: title,
              rightIcon: rightIcon ?? Icons.settings,
              onLeftIconPressed: onLeftIconPressed ?? () => Navigator.pop(context),
              onRightIconPressed: onRightIconPressed ?? () {},
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
