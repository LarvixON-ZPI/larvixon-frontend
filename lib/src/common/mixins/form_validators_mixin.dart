import 'package:flutter/widgets.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

mixin FormValidatorsMixin {
  String? lengthValidator(
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

  String? emailValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return context.translate.invalidEmailFormat;
    }
    return null;
  }

  String? passwordValidator(
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

  String? firstNameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  String? lastNameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  String? usernameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }
    return null;
  }

  String? confirmPasswordValidator(
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

  String? validatePhoneNumber(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (!regex.hasMatch(value.trim())) {
      return context.translate.invalidPhoneNumber;
    }
    return null;
  }
}
