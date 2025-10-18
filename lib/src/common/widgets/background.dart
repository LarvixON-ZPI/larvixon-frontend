import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [colorScheme.inversePrimary, colorScheme.surfaceContainerLow]
              : [colorScheme.inversePrimary, colorScheme.primary],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class BackgroundWithLarvae extends StatelessWidget {
  final bool useBlur;
  final int larvaeCount;
  const BackgroundWithLarvae({
    super.key,
    this.useBlur = true,
    this.larvaeCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Background(),
        PetriDish(larvaeCount: larvaeCount),
        if (useBlur)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }
}
