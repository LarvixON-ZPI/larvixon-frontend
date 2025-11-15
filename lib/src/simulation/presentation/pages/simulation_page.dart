import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class SimulationPage extends StatefulWidget {
  static const String route = '/simulation';
  static const String name = 'simulation';

  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  UnityWidgetController? _unityWidgetController;
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double maxWidth = 1552;
        final double width = constraints.maxWidth.clamp(0, maxWidth);

        return SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: kDefaultPageWidthConstraitns,
                    child: Column(
                      children: [
                        HeaderSectionBase(
                          title: context.translate.simulation,
                          subtitle: context.translate.simulationDescription,
                        ),
                        CustomCard(
                          child: Column(
                            spacing: 6,
                            children: [
                              _HowToStep(
                                number: 1,
                                text: context.translate.simulation_how_to_1,
                              ),
                              _HowToStep(
                                number: 2,
                                text: context.translate.simulation_how_to_2,
                              ),
                              _HowToStep(
                                number: 3,
                                text: context.translate.simulation_how_to_3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ConstrainedBox(
                    constraints: kDefaultPageWidthConstraitns,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        CustomCard(
                          child: IconButton(
                            onPressed: _isPaused ? null : _onPause,
                            icon: const Icon(Icons.pause),
                            tooltip: context.translate.pause,
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.resolveWith(
                                (states) =>
                                    states.contains(WidgetState.disabled)
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        CustomCard(
                          child: IconButton(
                            onPressed: _isPaused ? _onResume : null,
                            icon: const Icon(Icons.play_arrow),
                            tooltip: context.translate.resume,
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.resolveWith(
                                (states) =>
                                    states.contains(WidgetState.disabled)
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        CustomCard(
                          child: IconButton(
                            onPressed: _onRestart,
                            icon: const Icon(Icons.restart_alt),
                            tooltip: context.translate.restart,
                          ),
                        ),
                        CustomCard(
                          child: IconButton(
                            onPressed: _onToggleUI,
                            icon: const Icon(Icons.layers),
                            tooltip: context.translate.toggleUI,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: width,
                      maxHeight: width,
                    ),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FittedBox(
                      child: SizedBox(
                        width: width,
                        height: width / 2,
                        child: UnityWidget(
                          onUnityCreated: onUnityCreated,
                          onUnityMessage: onUnityMessage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  void _sendMessageToUnity(String message) {
    if (_unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'FlutterReceiver',
        'HandleWebFnCall',
        message,
      );
    }
  }

  void _onPause() {
    if (_unityWidgetController != null) {
      setState(() {
        _isPaused = true;
      });
      _sendMessageToUnity('pause');
    }
  }

  void _onResume() {
    if (_unityWidgetController != null) {
      setState(() {
        _isPaused = false;
      });
      _sendMessageToUnity('resume');
    }
  }

  void _onRestart() {
    if (_unityWidgetController != null) {
      setState(() {
        _isPaused = false;
      });
      _sendMessageToUnity('restart');
    }
  }

  void _onToggleUI() {
    if (_unityWidgetController != null) {
      _sendMessageToUnity('ui');
    }
  }

  void onUnityMessage(dynamic message) {}

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }
}

class _HowToStep extends StatelessWidget {
  final int number;
  final String text;

  const _HowToStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 12, child: Text(number.toString())),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
