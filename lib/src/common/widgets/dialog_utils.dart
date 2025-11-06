import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class DialogUtils {
  static Future<T?> showScaleDialog<T>({
    required BuildContext context,
    required Widget child,
    String barrierLabel = "Dialog",
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutBack,
    bool barrierDismissible = true,
    BoxConstraints constraints = const BoxConstraints(maxWidth: 600),
    Widget? title,
    Widget? description,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: curve),
          child: Center(
            child: ConstrainedBox(
              constraints: constraints,
              child: CustomCard(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.8),
                title: title,
                description: description,
                child: child,
              ),
            ),
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}
