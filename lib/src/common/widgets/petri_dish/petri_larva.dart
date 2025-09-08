import 'dart:math';

import 'package:flutter/material.dart';

class PetriLarva {
  Offset position;

  final int segments;

  final double segmentLength;

  late List<Offset> segmentPositions;

  double crawlPhase = 0;

  Offset velocity = Offset.zero;

  final Random _random = Random();

  Offset targetVelocity = Offset.zero;

  PetriLarva({
    required this.position,
    required this.segments,
    required this.segmentLength,
  }) {
    segmentPositions = List.generate(segments, (index) {
      return Offset(position.dx - index * segmentLength, position.dy);
    });
    _selectTarget();
  }

  void update(Offset? target, Size bounds) {
    _updatePosition(target, bounds);
    _updateSegments();
    crawlPhase += 0.05;
  }

  void _updatePosition(Offset? target, Size bounds) {
    if (target != null) {
      _moveTowardTarget(target);
    } else {
      _moveRandomly(bounds);
    }

    position = Offset(
      position.dx.clamp(0, bounds.width),
      position.dy.clamp(0, bounds.height),
    );
  }

  void _moveTowardTarget(Offset target) {
    final dx = target.dx - position.dx;
    final dy = target.dy - position.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final step = min(0.5, distance);
    if (distance > 1) {
      position = Offset(
        position.dx + dx / distance * step,
        position.dy + dy / distance * step,
      );
    }
  }

  void _moveRandomly(Size bounds) {
    if (position.dx <= 0 || position.dx >= bounds.width) {
      targetVelocity = Offset(-targetVelocity.dx, targetVelocity.dy);
    }
    if (position.dy <= 0 || position.dy >= bounds.height) {
      targetVelocity = Offset(targetVelocity.dx, -targetVelocity.dy);
    }

    if (_random.nextInt(1000) < 5) {
      _selectTarget();
    }

    velocity = Offset.lerp(velocity, targetVelocity, 0.05)!;
    position += velocity;
  }

  void _updateSegments() {
    segmentPositions[0] = position;
    for (int i = 1; i < segments; i++) {
      final prev = segmentPositions[i - 1];
      final curr = segmentPositions[i];
      final crawlOffset = sin(crawlPhase - i * 0.3) * segmentLength * 0.5;
      final dir = prev - curr;
      final dist = dir.distance;
      if (dist != 0) {
        segmentPositions[i] =
            prev - (dir / dist * (segmentLength + crawlOffset));
      } else {
        segmentPositions[i] = prev;
      }
    }
  }

  void _selectTarget() {
    final angle = _random.nextDouble() * 2 * pi;
    targetVelocity = Offset(cos(angle) * 1, sin(angle) * 1);
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    final length = this.distance;
    return length == 0 ? Offset.zero : this / length;
  }
}
