import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish.dart';
import 'package:larvixon_frontend/src/landing/presentation/background.dart';
import 'package:larvixon_frontend/src/landing/presentation/footer.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing_navbar.dart';

class LandingScaffold extends StatelessWidget {
  final Widget child;
  const LandingScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Background(),
          Positioned.fill(child: PetriDish(larvaeCount: 3)),
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
          Column(
            children: [
              LandingNavBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: child,
                ),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: Footer()),
        ],
      ),
    );
  }
}
