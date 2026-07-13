import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'loading.dart';

/// Kompas w klimacie pirackim: mosiężna, oktagonalna obudowa z pergaminową
/// tarczą, przechylona w pseudo-3D (perspective transform), z igłą
/// wskazującą namiar (bearing) na cel niezależnie od obrotu telefonu.
class PirateCompass extends StatefulWidget {
  const PirateCompass({super.key, required this.bearingToTarget});

  /// Namiar (0-360°, 0 = północ) z pozycji użytkownika do celu.
  final double bearingToTarget;

  @override
  State<PirateCompass> createState() => _PirateCompassState();
}

class _PirateCompassState extends State<PirateCompass> {
  double? _smoothedNeedleAngle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        if (heading == null) {
          return const SizedBox(width: 300, height: 300, child: CustomLoading());
        }

        // Igła ma wskazywać cel niezależnie od tego, w którą stronę
        // obrócony jest telefon.
        final targetAngle = (widget.bearingToTarget - heading) * (math.pi / 180);
        _smoothedNeedleAngle = _shortestAngleLerp(_smoothedNeedleAngle, targetAngle);

        return SizedBox(
          width: 300,
          height: 300,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0018)
              ..rotateX(-0.35),
            child: CustomPaint(
              painter: _PirateCompassPainter(needleAngle: _smoothedNeedleAngle!),
            ),
          ),
        );
      },
    );
  }

  double _shortestAngleLerp(double? current, double target) {
    if (current == null) return target;
    var delta = (target - current) % (2 * math.pi);
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;
    return current + delta * 0.15;
  }
}

class _PirateCompassPainter extends CustomPainter {
  _PirateCompassPainter({required this.needleAngle});

  final double needleAngle;

  static const _wood = Color(0xFF3B2A1A);
  static const _woodLight = Color(0xFF5A4326);
  static const _brass = Color(0xFFC9A227);
  static const _brassDark = Color(0xFF8A6E1D);
  static const _parchment = Color(0xFFE8DEB8);
  static const _parchmentShadow = Color(0xFFC9BB84);
  static const _ink = Color(0xFF3A2E1F);
  static const _needleRed = Color(0xFF8B1E1E);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    _drawOctagonCase(canvas, center, radius);
    _drawDial(canvas, center, radius * 0.82);
    _drawNeedle(canvas, center, radius * 0.68);
    _drawCenterPin(canvas, center, radius * 0.06);
  }

  Path _octagonPath(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i - math.pi / 8;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  void _drawOctagonCase(Canvas canvas, Offset center, double radius) {
    final woodPath = _octagonPath(center, radius);
    final woodPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_woodLight, _wood],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(woodPath, woodPaint);

    final brassRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.09
      ..color = _brass;
    canvas.drawPath(_octagonPath(center, radius * 0.93), brassRimPaint);

    final innerRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.02
      ..color = _brassDark;
    canvas.drawPath(_octagonPath(center, radius * 0.86), innerRimPaint);

    // Nity na rogach obudowy.
    final rivetPaint = Paint()..color = _brassDark;
    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i - math.pi / 8;
      final rivetCenter = Offset(
        center.dx + radius * 0.96 * math.cos(angle),
        center.dy + radius * 0.96 * math.sin(angle),
      );
      canvas.drawCircle(rivetCenter, radius * 0.025, rivetPaint);
    }
  }

  void _drawDial(Canvas canvas, Offset center, double radius) {
    final dialPaint = Paint()
      ..shader = RadialGradient(
        colors: [_parchment, _parchmentShadow],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, dialPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.02
      ..color = _ink.withValues(alpha: 0.5);
    canvas.drawCircle(center, radius * 0.95, ringPaint);

    // Gwiazda kompasu - promienie w stylu starej mapy skarbów.
    final rayPaintMajor = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.03
      ..color = _needleRed.withValues(alpha: 0.75);
    final rayPaintMinor = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.012
      ..color = _ink.withValues(alpha: 0.55);

    for (var i = 0; i < 16; i++) {
      final angle = (math.pi / 8) * i;
      final isMajor = i % 4 == 0;
      final inner = radius * 0.12;
      final outer = isMajor ? radius * 0.9 : radius * 0.55;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle), center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle), center.dy + outer * math.sin(angle)),
        isMajor ? rayPaintMajor : rayPaintMinor,
      );
    }

    // Litery N/E/S/W.
    const labels = ['N', 'E', 'S', 'W'];
    for (var i = 0; i < 4; i++) {
      final angle = (math.pi / 2) * i - math.pi / 2;
      final labelOffset = Offset(
        center.dx + radius * 0.72 * math.cos(angle),
        center.dy + radius * 0.72 * math.sin(angle),
      );
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: i == 0 ? _needleRed : _ink,
            fontSize: radius * 0.16,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        labelOffset - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double length) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(needleAngle);

    final northPath = Path()
      ..moveTo(0, -length)
      ..lineTo(length * 0.13, 0)
      ..lineTo(-length * 0.13, 0)
      ..close();
    canvas.drawPath(northPath, Paint()..color = _needleRed);

    final southPath = Path()
      ..moveTo(0, length * 0.55)
      ..lineTo(length * 0.1, 0)
      ..lineTo(-length * 0.1, 0)
      ..close();
    canvas.drawPath(southPath, Paint()..color = _brassDark);

    canvas.restore();
  }

  void _drawCenterPin(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = _brass);
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()..color = _brassDark,
    );
  }

  @override
  bool shouldRepaint(covariant _PirateCompassPainter oldDelegate) {
    return oldDelegate.needleAngle != needleAngle;
  }
}
