import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/analysis_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String route = '/home';
  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return const LarvaVideoGrid();
  }
}
