import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // change if needed
      body: const Center(
        child: Image(
          image: AssetImage('assets/splash.png'), // your image path
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
