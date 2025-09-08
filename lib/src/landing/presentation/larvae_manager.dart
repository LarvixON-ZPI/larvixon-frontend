import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_larva.dart';

/// Manages a collection of larvae and their interactions with the container
class LarvaeManager {
  /// List of larvae managed by this class
  List<PetriLarva>? _larvae;

  /// Number of larvae to create
  final int larvaeCount;

  /// Current size of the container
  Size? _containerSize;

  /// Position of the cursor/pointer when hovering
  Offset? _cursorPosition;

  /// Creates a new larvae manager with the specified number of larvae
  LarvaeManager({required this.larvaeCount});

  /// Gets the list of managed larvae
  List<PetriLarva> get larvae {
    if (_larvae == null) {
      if (_containerSize == null) {
        throw StateError('Container size must be set before accessing larvae');
      }
      _initializeLarvae();
    }
    return _larvae!;
  }

  /// Updates the cursor position
  set cursorPosition(Offset? position) {
    _cursorPosition = position;
  }

  /// Gets the current cursor position
  Offset? get cursorPosition => _cursorPosition;

  /// Updates the container size and scales larvae positions if needed
  void updateContainerSize(Size newSize) {
    if (_containerSize != null &&
        _larvae != null &&
        _containerSize != newSize) {
      _scaleLarvaePositions(_containerSize!, newSize);
    }

    _containerSize = newSize;
  }

  /// Initializes the larvae list with random positions
  void _initializeLarvae() {
    final width = _containerSize!.width;
    final height = _containerSize!.height;
    final random = Random();

    _larvae = List.generate(
      larvaeCount,
      (index) => PetriLarva(
        position: Offset(
          random.nextDouble() * width,
          random.nextDouble() * height,
        ),
        segments: 32,
        segmentLength: 2,
      ),
    );
  }

  /// Scales the larvae positions when the container size changes
  void _scaleLarvaePositions(Size oldSize, Size newSize) {
    final scaleX = newSize.width / oldSize.width;
    final scaleY = newSize.height / oldSize.height;

    for (var larva in _larvae!) {
      larva.position = Offset(
        larva.position.dx * scaleX,
        larva.position.dy * scaleY,
      );
    }
  }

  /// Updates all larvae positions and segments
  void update() {
    if (_larvae == null || _containerSize == null) return;

    for (var larva in _larvae!) {
      larva.update(_cursorPosition, _containerSize!);
    }
  }
}
