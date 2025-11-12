import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with FormValidatorsMixin {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.translate.messageSentAcknowledgment)),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomCard(
            title: Center(
              child: Text(
                context.translate.contact,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            description: Text(
              context.translate.contactDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: CustomCard(
            child: Column(
              children: [
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
                              validator: (v) => firstNameValidator(context, v),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: context.translate.email,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => emailValidator(context, v),
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
                        validator: (v) => lengthValidator(
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
        ),
      ],
    );
  }
}
