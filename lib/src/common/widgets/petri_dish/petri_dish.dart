import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/larvae_manager.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish_painter.dart';

class PetriDish extends StatefulWidget {
  final int larvaeCount;

  const PetriDish({super.key, this.larvaeCount = 1});

  @override
  State<PetriDish> createState() => _PetriDishState();
}

class _PetriDishState extends State<PetriDish>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late LarvaeManager _larvaeManager;

  @override
  void initState() {
    super.initState();

    _larvaeManager = LarvaeManager(larvaeCount: widget.larvaeCount);

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 100))
          ..addListener(_updateLarvae)
          ..repeat();
  }

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
