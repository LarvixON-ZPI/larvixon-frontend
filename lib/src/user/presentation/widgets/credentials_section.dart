import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class CredentialsSection extends StatelessWidget {
  const CredentialsSection({
    super.key,
    required this.direction,
    required this.username,
    required this.email,
  });

  final Axis direction;
  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        direction: direction,
        children: [
          Flexible(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.translate.username),
                TextFormField(initialValue: username, readOnly: true),
              ],
            ),
          ),
          Flexible(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.translate.email),
                TextFormField(initialValue: email, readOnly: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
