import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/landing/presentation/custom_card.dart';

import '../../common/extensions/translate_extension.dart';
import '../../../src/authentication/auth_form_validators.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement actual submission logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message sent — thank you!')));

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translate.contact,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Have a question or want to collaborate? Drop us a message.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        SizedBox(
          width: double.infinity,
          child: CustomCard(
            title: context.translate.sendUsAMessage,
            widgets: [
              Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: context.translate.firstName,
                            ),
                            validator: (v) =>
                                FormValidators.firstNameValidator(context, v),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: context.translate.email,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                FormValidators.emailValidator(context, v),
                          ),
                        ),
                      ],
                    ),

                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: context.translate.message,
                      ),
                      minLines: 3,
                      maxLines: 6,
                      validator: (v) => FormValidators.lengthValidator(
                        context,
                        v,
                        fieldName: context.translate.message,
                        minLength: 10,
                        maxLength: 512,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(context.translate.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
