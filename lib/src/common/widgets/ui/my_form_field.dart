import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback? toggleObscure;
  final bool Function(String field) shouldValidate;
  final String? Function(String field) fieldError;
  final String? Function(BuildContext, String?) validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;

  const MyFormField({
    super.key,
    required this.fieldName,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.toggleObscure,
    required this.shouldValidate,
    required this.fieldError,
    required this.validator,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: obscure && toggleObscure != null
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleObscure,
              )
            : null,
      ),
      obscureText: obscure,
      autovalidateMode: shouldValidate(fieldName)
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      validator: (value) =>
          fieldError(fieldName) ??
          (shouldValidate(fieldName) ? validator(context, value) : null),
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
    );
  }
}
