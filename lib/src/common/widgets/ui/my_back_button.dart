import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBackButton extends StatelessWidget {
  final String? fallbackRoute;
  final VoidCallback? onPressed;

  const MyBackButton({super.key, this.fallbackRoute, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else if (context.canPop()) {
          context.pop();
        } else if (fallbackRoute != null) {
          context.go(fallbackRoute!);
        }
      },
    );
  }
}
