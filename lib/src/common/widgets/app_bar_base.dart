// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:larvixon_frontend/core/constants/breakpoints.dart';

import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';

import '../../common/extensions/translate_extension.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? children;
  final Widget? menu;
  final Widget? rightChild;
  final Widget? title;

  const AppBarBase({
    super.key,
    this.children,
    this.rightChild,
    this.menu,
    this.title,
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
      actions: isNarrow
          ? (rightChild != null ? [rightChild!] : null)
          : (children ?? []),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
