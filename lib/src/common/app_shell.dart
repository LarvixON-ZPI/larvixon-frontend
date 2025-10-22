import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/background.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  const AppShell({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [const BackgroundWithLarvae(), child],
      ),
    );
  }
}
