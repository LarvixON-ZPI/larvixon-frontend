import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';

class LandingEmailForm extends StatefulWidget {
  const LandingEmailForm({super.key});

  @override
  State<LandingEmailForm> createState() => _LandingEmailFormState();
}

class _LandingEmailFormState extends State<LandingEmailForm>
    with FormValidatorsMixin {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 100,
              child: TextFormField(
                validator: (value) => emailValidator(context, value),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: context.translate.enterEmail,

                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                context.push(
                  AuthPage.route,
                  extra: {
                    'email': _emailController.text,
                    'mode': AuthFormMode.signUp,
                  },
                );
              },
              child: Text(context.translate.getStarted),
            ),
          ),
        ],
      ),
    );
  }
}
