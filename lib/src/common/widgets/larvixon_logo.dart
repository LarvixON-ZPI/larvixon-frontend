// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class LarvixonLogo extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool useFull;
  const LarvixonLogo({super.key, this.onPressed, this.useFull = true});
  static const String full = "assets/images/logo/logo_light.svg";
  static const String logoOnly = "assets/images/logo/logo_only_light.svg";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: kToolbarHeight,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SvgPicture.asset(
            useFull ? full : logoOnly,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
