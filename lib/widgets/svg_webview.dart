import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SvgWebView extends StatefulWidget {
  final String svgContent;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const SvgWebView({
    super.key,
    required this.svgContent,
    this.width = 200,
    this.height = 200,
    this.onTap,
  });

  @override
  State<SvgWebView> createState() => _SvgWebViewState();
}

class _SvgWebViewState extends State<SvgWebView> {
  WebViewController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initWebView();
    });
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(_buildHtml());
    if (mounted) setState(() => _ready = true);
  }

  @override
  void didUpdateWidget(SvgWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgContent != widget.svgContent) {
      _controller = null;
      _ready = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _initWebView();
      });
    }
  }

  String _buildHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      width: 100vw; height: 100vh;
      display: flex; align-items: center; justify-content: center;
      background: transparent;
      overflow: hidden;
    }
    svg { max-width: 100%; max-height: 100%; }
  </style>
</head>
<body>
  ${widget.svgContent}
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          if (_ready && _controller != null)
            WebViewWidget(controller: _controller!)
          else
            const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
