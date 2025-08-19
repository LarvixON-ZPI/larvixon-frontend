import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
