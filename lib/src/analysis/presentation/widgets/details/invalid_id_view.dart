import 'package:flutter/material.dart';

class InvalidIdView extends StatelessWidget {
  const InvalidIdView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Analysis ID is missing')));
  }
}
