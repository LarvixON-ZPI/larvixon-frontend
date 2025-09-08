import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_larva.dart';

class PetriDishPainter extends CustomPainter {
  final List<PetriLarva> larvae;

  PetriDishPainter(this.larvae);

  @override
  void paint(Canvas canvas, Size size) {
    _drawPetriDish(canvas, size);

    for (var larva in larvae) {
      _drawLarva(canvas, larva);
    }
  }

  void _drawPetriDish(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final dishRRect = RRect.fromRectAndRadius(
      rect.inflate(12),
      const Radius.circular(24),
    );

    final outerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.6),
          Colors.white.withValues(alpha: 0.1),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRRect(dishRRect, outerPaint);

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
      ).createShader(rect);
    canvas.drawRRect(dishRRect, glowPaint);
  }

  void _drawLarva(Canvas canvas, PetriLarva larva) {
    final points = larva.segmentPositions;
    if (points.isEmpty) return;

    final larvaPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyePaint = Paint()..color = Colors.black;

    _drawLarvaSegments(canvas, points, larvaPaint);

    _drawLarvaEyes(canvas, points, eyePaint);
  }

  void _drawLarvaSegments(
    Canvas canvas,
    List<Offset> points,
    Paint larvaPaint,
  ) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      Offset segmentDirection;

      if (i < points.length - 1) {
        segmentDirection = (points[i + 1] - point).normalize();
      } else if (i > 0) {
        segmentDirection = (point - points[i - 1]).normalize();
      } else {
        segmentDirection = const Offset(1, 0);
      }

      final double angle = atan2(segmentDirection.dy, segmentDirection.dx);
      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(angle + pi / 2);

      const double segmentWidth = 20;
      const double segmentHeight = 40;
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: segmentWidth,
        height: segmentHeight,
      );

      canvas.drawOval(rect, larvaPaint);
      canvas.restore();
    }
  }

  void _drawLarvaEyes(Canvas canvas, List<Offset> points, Paint eyePaint) {
    if (points.length >= 2) {
      final head = points[0];
      final neck = points[1];
      final direction = (head - neck).normalize();
      final perpendicular = Offset(-direction.dy, direction.dx);

      const double eyeOffset = 5.0;
      const double eyeRadius = 3.0;

      final Offset leftEye = head + perpendicular * eyeOffset;
      final Offset rightEye = head - perpendicular * eyeOffset;

      canvas.drawCircle(leftEye, eyeRadius, eyePaint);
      canvas.drawCircle(rightEye, eyeRadius, eyePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PetriDishPainter oldDelegate) => true;
}
