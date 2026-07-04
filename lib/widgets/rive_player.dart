import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RivePlayerWidget extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const RivePlayerWidget({
    super.key,
    required this.assetPath,
    this.width = 200,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RiveAnimation.asset(
        assetPath,
        fit: BoxFit.contain,
        animations: const [],
      ),
    );
  }
}
