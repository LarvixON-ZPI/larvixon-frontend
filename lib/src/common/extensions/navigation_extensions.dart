import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationExtensions on BuildContext {
  void popMaybe<T extends Object?>([T? result]) {
    if (canPop()) pop(result);
  }

  void popOrGo(String location, {Object? extra}) {
    if (canPop()) return pop();
    go(location, extra: extra);
  }
}
