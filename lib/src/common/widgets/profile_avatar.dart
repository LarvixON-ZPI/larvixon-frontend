import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  const ProfileAvatar({super.key, this.size = 120, this.imageUrl, this.onTap});

  final double size;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null;
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size,
        backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
        child: hasImage
            ? null
            : Icon(Icons.person, size: size, color: Colors.grey),
      ).withOnHoverEffect,
    );
  }
}
