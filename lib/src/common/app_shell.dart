import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/background.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final Widget? appBar;
  final Widget? footer;
  const AppShell({super.key, required this.child, this.appBar, this.footer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundWithLarvae(),
          CustomScrollView(
            slivers: [
              if (appBar != null) appBar!,
              SliverFillRemaining(child: child),
              if (footer != null) SliverToBoxAdapter(child: footer),
            ],
          ),
        ],
      ),
    );
  }
}
