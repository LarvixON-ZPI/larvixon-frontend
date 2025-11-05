import 'package:flutter/material.dart';

mixin FieldErrorMixin<T extends StatefulWidget> on State<T> {
  Map<String, String> _fieldErrors = {};

  Map<String, String> get fieldErrors => _fieldErrors;

  void setFieldErrors(Map<String, String> errors) {
    if (mounted) {
      setState(() => _fieldErrors = Map.unmodifiable(errors));
    }
  }

  void setFieldError(String field, String error) {
    final updated = Map<String, String>.from(_fieldErrors);
    updated[field] = error;
    if (mounted) {
      setState(() => _fieldErrors = Map.unmodifiable(updated));
    }
  }

  String? errorFor(String field) => _fieldErrors[field];

  void clearError(String field) {
    if (_fieldErrors.containsKey(field)) {
      final updated = Map<String, String>.from(_fieldErrors)..remove(field);
      if (mounted) setState(() => _fieldErrors = updated);
    }
  }

  void clearAllErrors() {
    if (_fieldErrors.isNotEmpty && mounted) {
      setState(() => _fieldErrors = {});
    }
  }
}

mixin FormFieldValidationMixin<T extends StatefulWidget> on FieldErrorMixin<T> {
  final Set<String> _validatedFields = {};

  bool shouldValidate(String field) =>
      _validatedFields.contains(field) || errorFor(field) != null;

  String? validateField(
    BuildContext context,
    String fieldName,
    String? Function(BuildContext, String?) validator,
    String? value,
  ) {
    final fieldError = errorFor(fieldName);
    if (fieldError != null) return fieldError;

    if (_validatedFields.contains(fieldName)) {
      return validator(context, value);
    }
    return null;
  }

  void markFieldValidated(String fieldName) {
    if (_validatedFields.add(fieldName) && mounted) {
      setState(() {});
    }
  }

  void markFieldsValidated(Iterable<String> fieldNames) {
    final before = _validatedFields.length;
    _validatedFields.addAll(fieldNames);
    if (_validatedFields.length != before && mounted) {
      setState(() {});
    }
  }

  void onFieldChanged(String fieldName) {
    _validatedFields.add(fieldName);
    clearError(fieldName);
  }

  void clearValidatedFields() {
    _validatedFields.clear();
  }

  AutovalidateMode getAutovalidateMode(String fieldName) {
    if (shouldValidate(fieldName)) return AutovalidateMode.always;
    return AutovalidateMode.disabled;
  }
}
