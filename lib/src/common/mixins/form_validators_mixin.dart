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

  String? peselValidator(
    BuildContext context,
    String? value, [
    bool allowDirty = false,
  ]) {
    if (value == null || value.isEmpty) {
      return context.translate.fieldIsRequired;
    }

    final pesel = value.replaceAll(RegExp(r'\s'), '');

    if (pesel.length != 11 || !RegExp(r'^\d{11}$').hasMatch(pesel)) {
      return context.translate.peselMustBe11Digits;
    }
    if (allowDirty) return null;
    final weights = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3];
    int sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(pesel[i]) * weights[i];
    }
    final checksum = (10 - (sum % 10)) % 10;
    final lastDigit = int.parse(pesel[10]);

    if (checksum != lastDigit) {
      return context.translate.invalidPeselNumber;
    }

    return null;
  }
}
