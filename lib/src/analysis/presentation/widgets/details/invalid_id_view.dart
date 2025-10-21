import 'package:flutter/material.dart';

class InvalidIdView extends StatelessWidget {
  const InvalidIdView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Analysis ID is missing')));
  }
}
