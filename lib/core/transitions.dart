import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SlideFrom {
  left,
  right,
  top,
  bottom;

  get offset {
    switch (this) {
      case SlideFrom.left:
        return const Offset(-1, 0);
      case SlideFrom.right:
        return const Offset(1, 0);
      case SlideFrom.top:
        return const Offset(0, -1);
      case SlideFrom.bottom:
        return const Offset(0, 1);
    }
  }

  get opposite {
    switch (this) {
      case SlideFrom.left:
        return SlideFrom.right;
      case SlideFrom.right:
        return SlideFrom.left;
      case SlideFrom.top:
        return SlideFrom.bottom;
      case SlideFrom.bottom:
        return SlideFrom.top;
    }
  }
}

extension PageTransitionExtension on Widget {
  Page<T> withFadeTransition<T>(GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );
        final curvedSecondary = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeIn,
        );

        final opacityTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnim);
        final oldOpacityTween = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(curvedSecondary);

        return FadeTransition(
          opacity: oldOpacityTween,
          child: FadeTransition(opacity: opacityTween, child: child),
        );
      },
    );
  }

  Page<T> withSlideTransition<T>(
    GoRouterState state, {
    bool slideRight = true, // optional: control direction
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // direction for old and new pages
        final offsetEnd = slideRight
            ? const Offset(1, 0.0)
            : const Offset(-1, 0.0);
        final offsetBegin = slideRight
            ? const Offset(-1, 0.0)
            : const Offset(1, 0.0);

        // old page (secondaryAnimation) slides out
        final oldOffsetTween = Tween<Offset>(
          begin: Offset.zero,
          end: offsetEnd,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn));

        // new page (animation) slides in
        final newOffsetTween = Tween<Offset>(
          begin: offsetBegin,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn));

        return SlideTransition(
          position: oldOffsetTween.animate(secondaryAnimation),
          child: SlideTransition(
            position: newOffsetTween.animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Page<T> withoutTransition<T>({required GoRouterState state}) {
    return NoTransitionPage(key: state.pageKey, child: this);
  }
}
