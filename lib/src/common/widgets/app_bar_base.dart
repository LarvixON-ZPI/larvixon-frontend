// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:larvixon_frontend/core/constants/breakpoints.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? children;
  final Widget? menu;
  final Widget? rightChild;
  final Widget? title;
  final Color? backgroundColor;

  const AppBarBase({
    super.key,
    this.children,
    this.rightChild,
    this.menu,
    this.title,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < Breakpoints.medium;

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: isNarrow,
      title: title,
      leading: isNarrow ? menu : null,
      actionsPadding: const EdgeInsets.only(right: 16),

      actions: isNarrow
          ? (rightChild != null ? [rightChild!] : null)
          : (children ?? []),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: backgroundColor),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
