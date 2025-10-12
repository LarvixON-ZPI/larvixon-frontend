import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialMediaPlatform {
  linkedin(icon: FontAwesomeIcons.linkedin),
  github(icon: FontAwesomeIcons.github);

  final IconData icon;

  const SocialMediaPlatform({required this.icon});

  @override
  String toString() {
    return switch (this) {
      SocialMediaPlatform.linkedin => "LinkedIn",
      SocialMediaPlatform.github => "GitHub",
    };
  }
}

typedef SocialMediaLink = ({SocialMediaPlatform platform, String url});
