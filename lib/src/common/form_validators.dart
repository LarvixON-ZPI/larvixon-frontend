import 'package:flutter/widgets.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class FormValidators {
  static String? lengthValidator(
    BuildContext context,
    String? value, {
    required String fieldName,
    required int minLength,
    required int maxLength,
    bool allowNull = false,
  }) {
    if (allowNull && (value == null || value.isEmpty)) {
      return null;
    }
    if ((value == null || value.isEmpty)) {
      return context.translate.fieldIsRequired;
    }
    if (value.length < minLength) {
      return context.translate.fieldIsTooShort(fieldName, minLength);
    }
    if (value.length > maxLength) {
      return context.translate.fieldIsTooLong(fieldName, maxLength);
    }
    return null;
  }

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
