import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_larva.dart';

class LarvaeManager {
  List<PetriLarva>? _larvae;

  final int larvaeCount;

  Size? _containerSize;

  Offset? _cursorPosition;

  LarvaeManager({required this.larvaeCount});

  List<PetriLarva> get larvae {
    if (_larvae == null) {
      if (_containerSize == null) {
        throw StateError('Container size must be set before accessing larvae');
      }
      _initializeLarvae();
    }
    return _larvae!;
  }

  set cursorPosition(Offset? position) {
    _cursorPosition = position;
  }

  Offset? get cursorPosition => _cursorPosition;

  void updateContainerSize(Size newSize) {
    if (_containerSize != null &&
        _larvae != null &&
        _containerSize != newSize) {
      _scaleLarvaePositions(_containerSize!, newSize);
    }

    _containerSize = newSize;
  }

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
        segments: 10,
        segmentLength: 8.0,
      ),
    );
  }

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

  void update() {
    if (_larvae == null || _containerSize == null) return;

    for (var larva in _larvae!) {
      larva.update(_cursorPosition, _containerSize!);
    }
  }
}
