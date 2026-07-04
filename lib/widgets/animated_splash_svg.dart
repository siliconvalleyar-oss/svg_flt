import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedSplashSvg extends StatefulWidget {
  final double width;
  final double height;

  const AnimatedSplashSvg({
    super.key,
    this.width = 250,
    this.height = 250,
  });

  @override
  State<AnimatedSplashSvg> createState() => _AnimatedSplashSvgState();
}

class _AnimatedSplashSvgState extends State<AnimatedSplashSvg>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _elapsed = elapsed);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _SplashPainter(elapsedMs: _elapsed.inMilliseconds),
      ),
    );
  }
}

class _SplashPainter extends CustomPainter {
  final int elapsedMs;

  _SplashPainter({required this.elapsedMs});

  static const _rings = <_RingDef>[
    _RingDef(radius: 173, sw: 2, color: 0xFF659cc8, dash: [76, 4, 70], period: 30000, dir: 1, alpha: 0.191),
    _RingDef(radius: 181, sw: 2, color: 0xFF659cc8, dash: [2, 45, 161], period: 27500, dir: 1, alpha: 1.0),
    _RingDef(radius: 159, sw: 4, color: 0xFF78af9f, dash: [76, 4, 70], period: 19800, dir: -1, alpha: 1.0),
    _RingDef(radius: 159, sw: 4, color: 0xFF78af9f, dash: [46, 2, 12], period: 25400, dir: -1, alpha: 0.278),
    _RingDef(radius: 150, sw: 8, color: 0xFFdda032, dash: [76, 2, 40, 180], period: 26200, dir: 1, alpha: 1.0),
    _RingDef(radius: 165, sw: 8, color: 0xFFdda032, dash: [56, 2, 4], period: 27900, dir: 1, alpha: 0.688),
    _RingDef(radius: 141, sw: 4, color: 0xFFd36e2d, dash: [51, 4, 10, 80], period: 26800, dir: 1, alpha: 1.0),
    _RingDef(radius: 150, sw: 4, color: 0xFFd36e2d, dash: [140, 4, 10, 80], period: 16000, dir: 1, alpha: 0.441),
    _RingDef(radius: 130, sw: 2, color: 0xFFc13f21, dash: [35, 7, 10, 80], period: 16000, dir: 1, alpha: 1.0),
    _RingDef(radius: 130, sw: 2, color: 0xFFc13f21, dash: [35, 7, 10, 80], period: 16000, dir: 1, alpha: 0.278),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 366;
    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.save();
    canvas.translate(cx, cy);

    for (final r in _rings) {
      final paint = Paint()
        ..color = Color(r.color).withValues(alpha: r.alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r.sw * scale;

      final angle = r.period == 0
          ? 0.0
          : r.dir * ((elapsedMs % r.period) / r.period) * 2 * pi;

      _drawDashedRing(canvas, r.radius * scale, r.radius, r.dash, angle, paint);
    }

    canvas.restore();
  }

  void _drawDashedRing(
    Canvas canvas,
    double radiusPx,
    double radiusSvg,
    List<int> dashPattern,
    double rotationAngle,
    Paint paint,
  ) {
    final circSvg = 2 * pi * radiusSvg;
    double angle = rotationAngle;
    final endAngle = angle + 2 * pi;
    int idx = 0;

    while (angle < endAngle) {
      final len = dashPattern[idx % dashPattern.length].toDouble();
      final sweep = (len / circSvg) * 2 * pi;

      if (idx % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset.zero, radius: radiusPx),
          angle,
          sweep,
          false,
          paint,
        );
      }

      angle += sweep;
      idx++;
    }
  }

  @override
  bool shouldRepaint(_SplashPainter oldDelegate) => true;
}

class _RingDef {
  final double radius;
  final double sw;
  final int color;
  final List<int> dash;
  final int period;
  final int dir;
  final double alpha;

  const _RingDef({
    required this.radius,
    required this.sw,
    required this.color,
    required this.dash,
    required this.period,
    required this.dir,
    required this.alpha,
  });
}
