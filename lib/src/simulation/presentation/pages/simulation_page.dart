import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class SimulationPage extends StatefulWidget {
  static const String route = '/simulation';
  static const String name = 'simulation';

  const SimulationPage({Key? key}) : super(key: key);

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  // ignore: unused_field
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            print('Pop invoked: $didPop with result: $result');
          },
          child: Container(
            color: Colors.yellow,
            child: UnityWidget(onUnityCreated: onUnityCreated),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }
}
