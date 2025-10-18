import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

enum SortOrder { ascending, descending }

extension SortOrderTranslation on SortOrder {
  String translate(BuildContext context) {
    switch (this) {
      case SortOrder.ascending:
        return context.translate.ascending;
      case SortOrder.descending:
        return context.translate.descending;
    }
  }
}

extension SortOrderIcon on SortOrder {
  IconData get icon {
    switch (this) {
      case SortOrder.ascending:
        return FontAwesomeIcons.arrowUp;
      case SortOrder.descending:
        return FontAwesomeIcons.arrowDown;
    }
  }
}
