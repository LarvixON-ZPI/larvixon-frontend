import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/contact.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum ContactType {
  featureRequest,
  bug,
  question,
  other;

  String translate(BuildContext context) => switch (this) {
    ContactType.featureRequest => context.translate.featureRequest,
    ContactType.bug => context.translate.bug,
    ContactType.question => context.translate.question,
    ContactType.other => context.translate.other,
  };

  IconData get icon => switch (this) {
    ContactType.featureRequest => Icons.lightbulb_outline,
    ContactType.bug => Icons.bug_report_outlined,
    ContactType.question => Icons.help_outline,
    ContactType.other => Icons.chat_bubble_outline,
  };

  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      ContactType.featureRequest => colorScheme.primary,
      ContactType.bug => colorScheme.error,
      ContactType.question => colorScheme.tertiary,
      ContactType.other => colorScheme.secondary,
    };
  }
}

class ContactSection extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  const ContactSection({super.key, this.initialName, this.initialEmail});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with FormValidatorsMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  ContactType _contactType = ContactType.question;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    String? version;
    String? build;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      build = packageInfo.buildNumber;
    } catch (e) {
      // couldn't get the version - most likey dev build
    }
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    final subject = Uri.encodeComponent(
      'LarvixonApp/${_contactType.translate(context)} - ${_titleController.text}',
    );
    final versionLine = version != null ? 'Version: $version\n' : '';
    final buildLine = build != null ? 'Build: $build\n' : '';
    final languageLine = "${Localizations.localeOf(context).languageCode}\n";
    final body = Uri.encodeComponent(
      'Type: ${_contactType.translate(context)}\n'
      'Platform: $platform\n'
      '$languageLine'
      '$buildLine'
      '$versionLine'
      'Title: ${_titleController.text}\n\n'
      'Name: ${_nameController.text}\n'
      'Message:\n\n${_messageController.text}',
    );

    final uri = Uri.parse(
      'mailto:${ContactConstants.email}?subject=$subject&body=$body',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomCard(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: context.translate.title,
                    ),
                    validator: (v) => lengthValidator(
                      context,
                      v,
                      fieldName: context.translate.title,
                      minLength: 2,
                      maxLength: 100,
                    ),
                  ),
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
                      Flexible(
                        child: DropdownMenu<ContactType>(
                          initialSelection: _contactType,
                          expandedInsets: EdgeInsets.zero,
                          label: Text(context.translate.contactType),
                          leadingIcon: Icon(
                            _contactType.icon,
                            color: _contactType.getColor(context),
                          ),
                          enableSearch: false,
                          requestFocusOnTap: false,
                          dropdownMenuEntries: ContactType.values
                              .map(
                                (type) => DropdownMenuEntry(
                                  value: type,
                                  label: type.translate(context),
                                  leadingIcon: Icon(
                                    type.icon,
                                    color: type.getColor(context),
                                    size: 20,
                                  ),
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            if (value != null) {
                              setState(() {
                                _contactType = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: context.translate.message,
                    ),
                    minLines: 5,
                    maxLines: 10,
                    validator: (v) => lengthValidator(
                      context,
                      v,
                      fieldName: context.translate.message,
                      minLength: 10,
                      maxLength: 4192,
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
    );
  }
}
