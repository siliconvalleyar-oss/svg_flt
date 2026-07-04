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
      child: RiveWidgetBuilder(
        fileLoader: FileLoader.fromAsset(
          assetPath,
          riveFactory: Factory.flutter,
        ),
        builder: (context, state) {
          if (state is RiveLoaded) {
            return RiveWidget(
              controller: state.controller,
              fit: Fit.contain,
            );
          } else if (state is RiveFailed) {
            return const Center(
              child: Icon(Icons.error_outline, color: Colors.red),
            );
          }
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}
