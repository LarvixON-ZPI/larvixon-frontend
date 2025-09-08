import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/larvae_manager.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish_painter.dart';

/// A widget that displays a petri dish with animated larvae
class PetriDish extends StatefulWidget {
  /// The number of larvae to show in the petri dish
  final int larvaeCount;

  /// Creates a new petri dish widget with the specified number of larvae
  const PetriDish({super.key, this.larvaeCount = 1});

  @override
  State<PetriDish> createState() => _PetriDishState();
}

/// State for the PetriDish widget
class _PetriDishState extends State<PetriDish>
    with SingleTickerProviderStateMixin {
  /// Animation controller for continuous animation
  late AnimationController _controller;

  /// Manager for the larvae in the dish
  late LarvaeManager _larvaeManager;

  @override
  void initState() {
    super.initState();

    // Initialize the larvae manager
    _larvaeManager = LarvaeManager(larvaeCount: widget.larvaeCount);

    // Setup animation controller
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 100))
          ..addListener(_updateLarvae)
          ..repeat();
  }

  /// Updates the larvae positions on each animation frame
  void _updateLarvae() {
    setState(() {
      _larvaeManager.update();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Update container size in the larvae manager
        _larvaeManager.updateContainerSize(size);

        return MouseRegion(
          onHover: (event) =>
              _larvaeManager.cursorPosition = event.localPosition,
          onExit: (_) => _larvaeManager.cursorPosition = null,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: CustomPaint(
              painter: PetriDishPainter(_larvaeManager.larvae),
            ),
          ),
        );
      },
    );
  }
}
