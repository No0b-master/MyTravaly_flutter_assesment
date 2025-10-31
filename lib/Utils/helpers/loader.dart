import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Lottie.asset(
      'assets/animations/loader.json',
      height: 300,
      width: 300,
      frameRate: FrameRate.max,
      repeat: true,
    );
  }
}
