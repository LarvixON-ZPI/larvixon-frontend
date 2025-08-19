import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '/extensions/translate_extension.dart';
import 'auth_form_validators.dart';

class SignInForm extends StatefulWidget {
  static const String tab = 'login';
  const SignInForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  @override
  void dispose() {
    _loginPasswordController.dispose();
    _loginEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: context.translate.email),
            controller: _loginEmailController,
            autofillHints: [AutofillHints.email],
            validator: (value) =>
                AuthFormValidators.emailValidator(context, value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: context.translate.password),
            controller: _loginPasswordController,
            obscureText: true,
            autofillHints: [AutofillHints.password],
            validator: (value) => AuthFormValidators.passwordValidator(
              context,
              value,
              onlyCheckEmpty: true,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              context.read<AuthBloc>().add(
                AuthSignInRequested(
                  email: _loginEmailController.text.trim(),
                  password: _loginPasswordController.text.trim(),
                ),
              );
            },
            child: Text(context.translate.signIn),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
