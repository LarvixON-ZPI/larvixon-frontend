import 'package:flutter/widgets.dart';
import 'package:larvixon_frontend/extensions/translate_extension.dart';

class AuthFormValidators {
  static String? emailValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return context.translate.invalidEmailFormat;
    }
    return null;
  }

  static String? passwordValidator(
    BuildContext context,
    String? value, {
    bool onlyCheckEmpty = false,
  }) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    if (onlyCheckEmpty) {
      return null;
    }
    if (value.length < 6) {
      return context.translate.passwordIsTooShort(6);
    }
    return null;
  }

  static String? firstNameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  static String? lastNameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  static String? usernameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  static String? confirmPasswordValidator(
    BuildContext context,
    String? password,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    if (value != password) {
      return context.translate.passwordsDoNotMatch;
    }
    return null;
  }
}
