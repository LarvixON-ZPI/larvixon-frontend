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

  Offset? targetPosition;

  final double maxSpeed = 1.5;
  final double maxForce = 0.05;
  final double arrivalRadius = 50.0;
  final double reachedThreshold = 15.0;

  final double crawlPhaseIncrement = 0.05;
  final double crawlWaveOffset = 0.3;
  final double crawlAmplitude = 0.1;

  final double cursorMovementThreshold = 1.0;
  final double targetReachedDistance = 10.0;
  final double boundaryOffset = -20.0;

  final double maxBackwardAngle = pi / 3;

  Offset? _lastCursorPosition;
  bool _hasReachedCursor = false;

  PetriLarva({
    required this.position,
    required this.segments,
    required this.segmentLength,
  }) {
    segmentPositions = List.generate(segments, (index) {
      return Offset(position.dx - index * segmentLength, position.dy);
    });
    _selectRandomTarget(const Size(800, 600));
  }

  void update(Offset? target, Size bounds) {
    _updatePosition(target, bounds);
    _updateSegments();
    crawlPhase += crawlPhaseIncrement;
  }

  void _updatePosition(Offset? cursorTarget, Size bounds) {
    Offset steering;

    if (cursorTarget != null) {
      if (_lastCursorPosition == null ||
          (cursorTarget - _lastCursorPosition!).distance >
              cursorMovementThreshold) {
        _hasReachedCursor = false;
        _lastCursorPosition = cursorTarget;
      }

      final distanceToCursor = (cursorTarget - position).distance;

      if (distanceToCursor < reachedThreshold && !_hasReachedCursor) {
        _hasReachedCursor = true;
        _selectRandomTarget(bounds);
      }

      if (_hasReachedCursor) {
        if (targetPosition == null) {
          _selectRandomTarget(bounds);
        }

        final distanceToTarget = (targetPosition! - position).distance;
        if (distanceToTarget < targetReachedDistance) {
          _selectRandomTarget(bounds);
        }

        steering = _seek(targetPosition!);
      } else {
        steering = _seek(cursorTarget);
      }
    } else {
      _lastCursorPosition = null;
      _hasReachedCursor = false;

      if (targetPosition == null) {
        _selectRandomTarget(bounds);
      }

      final distanceToTarget = (targetPosition! - position).distance;
      if (distanceToTarget < targetReachedDistance) {
        _selectRandomTarget(bounds);
      }

      steering = _seek(targetPosition!);
    }

    velocity += steering;

    if (velocity.distance > maxSpeed) {
      velocity = velocity.normalize() * maxSpeed;
    }

    position += velocity;

    bool reachedBoundary = false;
    if (position.dx <= 0 || position.dx >= bounds.width) {
      position = Offset(position.dx.clamp(0, bounds.width), position.dy);
      reachedBoundary = true;
    }
    if (position.dy <= 0 || position.dy >= bounds.height) {
      position = Offset(position.dx, position.dy.clamp(0, bounds.height));
      reachedBoundary = true;
    }

    if (reachedBoundary && cursorTarget == null) {
      _selectRandomTarget(bounds);
    }
  }

  Offset _seek(Offset target) {
    Offset desired = target - position;
    final distance = desired.distance;

    if (distance < arrivalRadius) {
      final m = _map(distance, 0, arrivalRadius, 0, maxSpeed);
      desired = desired.normalize() * m;
    } else {
      desired = desired.normalize() * maxSpeed;
    }

    if (velocity.distance > 0.1) {
      final currentAngle = atan2(velocity.dy, velocity.dx);
      final desiredDir = desired.normalize();
      final desiredAngle = atan2(desiredDir.dy, desiredDir.dx);

      double angleDiff = desiredAngle - currentAngle;
      while (angleDiff > pi) {
        angleDiff -= 2 * pi;
      }
      while (angleDiff < -pi) {
        angleDiff += 2 * pi;
      }

      if (angleDiff.abs() > maxBackwardAngle) {
        final clampedAngle = angleDiff > 0
            ? maxBackwardAngle
            : -maxBackwardAngle;
        final constrainedAngle = currentAngle + clampedAngle;

        desired = Offset(
          cos(constrainedAngle) * desired.distance,
          sin(constrainedAngle) * desired.distance,
        );
      }
    }

    Offset steer = desired - velocity;

    if (steer.distance > maxForce) {
      steer = steer.normalize() * maxForce;
    }

    return steer;
  }

  double _map(
    double value,
    double start1,
    double stop1,
    double start2,
    double stop2,
  ) {
    return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
  }

  void _selectRandomTarget(Size bounds) {
    targetPosition = Offset(
      boundaryOffset +
          _random.nextDouble() * (bounds.width - 2 * boundaryOffset),
      boundaryOffset +
          _random.nextDouble() * (bounds.height - 2 * boundaryOffset),
    );
  }

  void _updateSegments() {
    segmentPositions[0] = position;
    for (int i = 1; i < segments; i++) {
      final prev = segmentPositions[i - 1];
      final curr = segmentPositions[i];
      final crawlOffset =
          sin(crawlPhase - i * crawlWaveOffset) *
          segmentLength *
          crawlAmplitude;
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
}

extension OffsetExtension on Offset {
  Offset normalize() {
    final length = distance;
    return length == 0 ? Offset.zero : this / length;
  }
}
