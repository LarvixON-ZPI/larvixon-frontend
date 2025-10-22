import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Text("${context.translate.loading}..."),
        ],
      ),
    );
  }
}
