import 'package:flutter/material.dart';

extension NavigatorPopIfCan on NavigatorState {
  void popIfCan<T extends Object?>([T? result]) {
    if (canPop()) pop(result);
  }
}
