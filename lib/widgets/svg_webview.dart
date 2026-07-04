import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SvgWebView extends StatefulWidget {
  final String svgContent;
  final double width;
  final double height;

  const SvgWebView({
    super.key,
    required this.svgContent,
    this.width = 200,
    this.height = 200,
  });

  @override
  State<SvgWebView> createState() => _SvgWebViewState();
}

class _SvgWebViewState extends State<SvgWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(_buildHtml());
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
      child: WebViewWidget(controller: _controller),
    );
  }
}
