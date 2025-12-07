import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_larva.dart';

class PetriDishPainter extends CustomPainter {
  final List<PetriLarva> larvae;

  static const double dishInflation = 12.0;
  static const double dishCornerRadius = 24.0;
  static const double dishBorderWidth = 6.0;
  static const double dishGlowOpacity = 0.05;
  static const double dishBorderOpacityMax = 0.6;
  static const double dishBorderOpacityMin = 0.1;

  static const int segmentResolution = 12;
  static const double bodyWidth = 10.0;
  static const int segmentSteps = 3;
  static const double headEllipseRadiusX = 18.0;
  static const double headEllipseRadiusY = 10.0;
  static const double tailEllipseRadiusX = 9.0;
  static const double tailEllipseRadiusY = 7.0;

  static const double smoothingFactor = 0.3;

  static const double headEndPosition = 0.2;
  static const double tailStartPosition = 0.7;
  static const double headWidthMax = 1.1;
  static const double headWidthMin = 0.9;
  static const double bodyWidthNormal = 1.0;
  static const double tailWidthMin = 0.7;

  static const double eyeOffset = 5.0;
  static const double eyeRadius = 3.0;

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
      rect.inflate(dishInflation),
      const Radius.circular(dishCornerRadius),
    );

    final outerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: dishBorderOpacityMax),
          Colors.white.withValues(alpha: dishBorderOpacityMin),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = dishBorderWidth;
    canvas.drawRRect(dishRRect, outerPaint);

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: dishGlowOpacity),
          Colors.transparent,
        ],
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

    final smoothedPoints = _getSmoothedPoints(points);

    _drawLarvaBody(canvas, smoothedPoints, larvaPaint);
    _drawLarvaEyes(canvas, points, eyePaint);
  }

  List<Offset> _getSmoothedPoints(List<Offset> originalPoints) {
    if (originalPoints.length < 3) return originalPoints;

    final smoothedPoints = List<Offset>.from(originalPoints);

    for (int i = 1; i < originalPoints.length - 1; i++) {
      final prev = originalPoints[i - 1];
      final curr = originalPoints[i];
      final next = originalPoints[i + 1];

      final midPoint = Offset(
        (prev.dx + next.dx) * 0.5,
        (prev.dy + next.dy) * 0.5,
      );

      smoothedPoints[i] = Offset(
        curr.dx + (midPoint.dx - curr.dx) * smoothingFactor,
        curr.dy + (midPoint.dy - curr.dy) * smoothingFactor,
      );
    }

    return smoothedPoints;
  }

  void _drawLarvaBody(Canvas canvas, List<Offset> points, Paint larvaPaint) {
    if (points.length < 2) return;

    final firstPoint = points.first;
    final secondPoint = points[1];
    final headDirection = (secondPoint - firstPoint).normalize();
    _drawEllipse(
      canvas,
      firstPoint,
      headDirection,
      headEllipseRadiusX,
      headEllipseRadiusY,
      larvaPaint,
    );

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      final dir = (p2 - p1).normalize();
      final perpendicular = Offset(-dir.dy, dir.dx);

      for (int step = 0; step < segmentSteps; step++) {
        final t = step / segmentSteps;
        final center = Offset(
          p1.dx + (p2.dx - p1.dx) * t,
          p1.dy + (p2.dy - p1.dy) * t,
        );

        final normalizedPos = (i + t) / (points.length - 1);
        final widthMultiplier = _getWidthMultiplier(normalizedPos);
        final currentWidth = bodyWidth * widthMultiplier;

        final circlePath = Path();
        for (
          int circleIndex = 0;
          circleIndex < segmentResolution;
          circleIndex++
        ) {
          final angle = (circleIndex / segmentResolution) * 2 * pi;
          final offset =
              Offset(
                perpendicular.dx * cos(angle) - dir.dx * sin(angle),
                perpendicular.dy * cos(angle) - dir.dy * sin(angle),
              ) *
              currentWidth;

          final point = center + offset;

          if (circleIndex == 0) {
            circlePath.moveTo(point.dx, point.dy);
          } else {
            circlePath.lineTo(point.dx, point.dy);
          }
        }
        circlePath.close();
        canvas.drawPath(circlePath, larvaPaint);
      }
    }

    final lastPoint = points.last;
    final secondLastPoint = points[points.length - 2];
    final tailDirection = (lastPoint - secondLastPoint).normalize();
    _drawEllipse(
      canvas,
      lastPoint,
      tailDirection,
      tailEllipseRadiusX,
      tailEllipseRadiusY,
      larvaPaint,
    );
  }

  void _drawEllipse(
    Canvas canvas,
    Offset center,
    Offset direction,
    double radiusX,
    double radiusY,
    Paint paint,
  ) {
    final perpendicular = Offset(-direction.dy, direction.dx);

    final path = Path();
    const int ellipseResolution = 32;

    for (int pointIndex = 0; pointIndex < ellipseResolution; pointIndex++) {
      final angle = (pointIndex / ellipseResolution) * 2 * pi;
      final x = cos(angle) * radiusX;
      final y = sin(angle) * radiusY;

      final point = center + direction * x + perpendicular * y;

      if (pointIndex == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _getWidthMultiplier(double normalizedPosition) {
    if (normalizedPosition < headEndPosition) {
      final headProgress = normalizedPosition / headEndPosition;
      return headWidthMax - headProgress * (headWidthMax - headWidthMin);
    } else if (normalizedPosition < tailStartPosition) {
      return bodyWidthNormal;
    } else {
      final tailProgress =
          (normalizedPosition - tailStartPosition) / (1.0 - tailStartPosition);
      return bodyWidthNormal - tailProgress * (bodyWidthNormal - tailWidthMin);
    }
  }

  void _drawLarvaEyes(Canvas canvas, List<Offset> points, Paint eyePaint) {
    if (points.length >= 2) {
      final head = points[0];
      final neck = points[1];
      final direction = (head - neck).normalize();
      final perpendicular = Offset(-direction.dy, direction.dx);

      final Offset leftEye = head + perpendicular * eyeOffset;
      final Offset rightEye = head - perpendicular * eyeOffset;

      canvas.drawCircle(leftEye, eyeRadius, eyePaint);
      canvas.drawCircle(rightEye, eyeRadius, eyePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PetriDishPainter oldDelegate) => true;
}
