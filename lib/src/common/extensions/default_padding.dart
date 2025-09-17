import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/padding.dart';

extension DefaultPagePadding on Widget {
  Widget get withDefaultPagePadding {
    return Padding(padding: kDefaultPagePadding, child: this);
  }
}
