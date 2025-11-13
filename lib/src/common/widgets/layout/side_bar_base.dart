import 'dart:ui';
import 'package:flutter/material.dart';

class SideBarBase extends StatelessWidget {
  final List<Widget>? children;
  final Widget? menu;
  final Widget? bottomChild;
  final Widget? title;
  final bool includeSafeArea;
  final Color? backgroundColor;

  const SideBarBase({
    super.key,
    this.children,
    this.menu,
    this.bottomChild,
    this.title,
    this.includeSafeArea = true,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: includeSafeArea,
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (menu != null) menu!,
                      if (title != null) ...[const SizedBox(height: 8), title!],
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(spacing: 8, children: children ?? []),
                  ),
                ),

                if (bottomChild != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bottomChild,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
