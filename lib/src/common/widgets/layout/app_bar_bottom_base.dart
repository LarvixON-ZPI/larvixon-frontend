import 'package:flutter/material.dart';

class AppBarBottomBase extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> children;

  final double height;

  final Color? backgroundColor;

  const AppBarBottomBase({
    super.key,
    required this.children,
    this.height = 50,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
