import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'rive_webview.dart';

class RivePlayerWidget extends StatefulWidget {
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
  State<RivePlayerWidget> createState() => _RivePlayerWidgetState();
}

class _RivePlayerWidgetState extends State<RivePlayerWidget> {
  bool _isLoadingVersion = true;
  bool _isV6 = false;
  Uint8List? _cachedData;

  @override
  void initState() {
    super.initState();
    _detectVersion();
  }

  Future<void> _detectVersion() async {
    try {
      Uint8List data;
      if (widget.assetPath != null) {
        final d = await rootBundle.load(widget.assetPath!);
        data = d.buffer.asUint8List(d.offsetInBytes, d.lengthInBytes);
      } else {
        data = await io.File(widget.filePath!).readAsBytes();
      }
      final major = data[4];
      if (mounted) {
        setState(() {
          _isV6 = major == 6;
          _isLoadingVersion = false;
          _cachedData = data;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingVersion = false;
          _isV6 = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingVersion) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_isV6) {
      final data = _cachedData;
      if (data == null) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 48),
          ),
        );
      }
      return RiveWebView(
        rivData: data,
        width: widget.width,
        height: widget.height,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveWidgetBuilder(
        fileLoader: widget.filePath != null
            ? FileLoader.fromUrl(
                Uri.file(widget.filePath!).toString(),
                riveFactory: Factory.flutter,
              )
            : FileLoader.fromAsset(
                widget.assetPath!,
                riveFactory: Factory.flutter,
              ),
        builder: (context, state) {
          if (state is RiveLoaded) {
            return RiveWidget(
              controller: state.controller,
              fit: Fit.contain,
            );
          } else if (state is RiveFailed) {
            debugPrint(
                'Rive error (${widget.assetPath ?? widget.filePath}): ${state.error}');
            return const Center(
              child: Icon(Icons.error_outline,
                  color: Colors.red, size: 48),
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
