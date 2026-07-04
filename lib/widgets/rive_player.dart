import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RivePlayerWidget extends StatelessWidget {
  final String? assetPath;
  final String? filePath;
  final double width;
  final double height;

  const RivePlayerWidget({
    super.key,
    this.assetPath,
    this.filePath,
    this.width = 200,
    this.height = 200,
  }) : assert(assetPath != null || filePath != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RiveWidgetBuilder(
        fileLoader: filePath != null
            ? FileLoader.fromUrl(
                Uri.file(filePath!).toString(),
                riveFactory: Factory.flutter,
              )
            : FileLoader.fromAsset(
                assetPath!,
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
