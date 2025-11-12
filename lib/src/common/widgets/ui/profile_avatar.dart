import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  const ProfileAvatar({super.key, this.size = 120, this.imageUrl, this.onTap});

  final double size;
  ImageProvider? get _imageProvider {
    if (imageUrl == null) return null;
    return imageUrl!.startsWith('assets/')
        ? AssetImage(imageUrl!)
        : NetworkImage(imageUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size,
        backgroundImage: _imageProvider,
        child: _imageProvider == null
            ? Icon(Icons.person, size: size, color: Colors.grey)
            : null,
      ).withOnHoverEffect,
    );
  }
}
