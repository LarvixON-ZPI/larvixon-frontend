import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/background.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final Widget? navbar;
  final Widget? footer;
  const AppShell({super.key, required this.child, this.navbar, this.footer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundWithLarvae(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (navbar != null) navbar!,
              Expanded(
                child: CustomScrollView(
                  slivers: [SliverToBoxAdapter(child: child)],
                ),
              ),
              if (footer != null) footer!,
            ],
          ),
        ],
      ),
    );
  }
}
