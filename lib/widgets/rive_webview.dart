import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RiveWebView extends StatefulWidget {
  final Uint8List rivData;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const RiveWebView({
    super.key,
    required this.rivData,
    this.width = 200,
    this.height = 200,
    this.onTap,
  });

  @override
  State<RiveWebView> createState() => _RiveWebViewState();
}

class _RiveWebViewState extends State<RiveWebView> {
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
    final base64 = base64Encode(widget.rivData);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; overflow: hidden; background: transparent; }
    canvas { width: 100%; height: 100%; display: block; }
  </style>
</head>
<body>
  <canvas id="canvas"></canvas>
  <script src="https://unpkg.com/@rive-app/canvas@2.23.0"></script>
  <script>
    (async function() {
      try {
        const base64 = '$base64';
        const resp = await fetch('data:application/octet-stream;base64,' + base64);
        const buffer = await resp.arrayBuffer();
        const r = new rive.Rive({
          buffer: buffer,
          canvas: document.getElementById('canvas'),
          autoplay: true,
          onLoad: function() {
            if (r) r.resizeDrawingSurfaceToCanvas();
          }
        });
      } catch(e) {
        console.error('Rive error:', e);
        document.body.innerHTML = '<div style="color:red;padding:20px;font-size:12px;">Rive error: ' + e.message + '</div>';
      }
    })();
  </script>
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
          WebViewWidget(controller: _controller),
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
