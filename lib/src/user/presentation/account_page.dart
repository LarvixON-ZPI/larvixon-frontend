import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/profile_avatar.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/form_validators.dart';
import 'package:larvixon_frontend/src/user/bloc/user_bloc.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';

class AccountPage extends StatefulWidget {
  static const String route = '/account';
  static const String name = 'account';
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends State<AccountPage> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _organizationController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _phoneNumberController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  void _setupControllers({required User? user}) {
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _bioController.text = user?.bio ?? '';
    _phoneNumberController.text = user?.phoneNumber ?? '';
    _organizationController.text = user?.organization ?? '';
  }

  @override
  void initState() {
    super.initState();
    _setupControllers(user: context.read<UserBloc>().state.user);
  }

  Function()? _onSavePressed(GlobalKey<FormState> formKey, UserState state) {
    return state.isUpdating
        ? null
        : () {
            if (_formKey.currentState!.validate()) {
              context.read<UserBloc>().add(
                UserProfileDataUpdateRequested(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  bio: _bioController.text,
                  phoneNumber: _phoneNumberController.text,
                  organization: _organizationController.text,
                ),
              );
              setState(() {
                isEditing = false;
              });
            }
          };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: BlocConsumer<UserBloc, UserState>(
            listenWhen: (previous, current) => previous.user != current.user,
            listener: (context, state) {
              _setupControllers(user: state.user);
            },
            builder: (context, state) {
              switch (state.status) {
                case UserStatus.initial:
                case UserStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case UserStatus.error:
                  return Center(child: Text('Error: ${state.errorMessage}'));
                case UserStatus.success:
                  final user = state.user;
                  if (user == null) {
                    return const Center(child: Text('No user data available.'));
                  }

                  return CustomCard(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Stack(
                      children: [
                        Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Header(
                                  username: user.username,
                                  email: user.email,
                                ),
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                spacing: 10.0,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: !isEditing,
                                          controller: _firstNameController,
                                          decoration: InputDecoration(
                                            labelText:
                                                context.translate.firstName,
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: (value) {
                                            return FormValidators.lengthValidator(
                                              context,
                                              value,
                                              fieldName:
                                                  context.translate.firstName,
                                              minLength: 0,
                                              maxLength: 150,
                                              allowNull: true,
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: !isEditing,
                                          controller: _lastNameController,
                                          decoration: InputDecoration(
                                            labelText:
                                                context.translate.lastName,
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: (value) {
                                            return FormValidators.lengthValidator(
                                              context,
                                              value,
                                              fieldName:
                                                  context.translate.lastName,
                                              minLength: 0,
                                              maxLength: 150,
                                              allowNull: true,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: !isEditing,
                                          controller: _phoneNumberController,
                                          decoration: InputDecoration(
                                            labelText:
                                                context.translate.phoneNumber,
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: (value) {
                                            return FormValidators.lengthValidator(
                                              context,
                                              value,
                                              fieldName:
                                                  context.translate.phoneNumber,
                                              minLength: 0,
                                              maxLength: 20,
                                              allowNull: true,
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: !isEditing,
                                          controller: _organizationController,
                                          decoration: InputDecoration(
                                            labelText:
                                                context.translate.organization,
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: (value) {
                                            return FormValidators.lengthValidator(
                                              context,
                                              value,
                                              fieldName: context
                                                  .translate
                                                  .organization,
                                              minLength: 0,
                                              maxLength: 255,
                                              allowNull: true,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  TextFormField(
                                    readOnly: !isEditing,
                                    controller: _bioController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: context.translate.bio,
                                    ),
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      return FormValidators.lengthValidator(
                                        context,
                                        value,
                                        fieldName: context.translate.bio,
                                        minLength: 0,
                                        maxLength: 500,
                                        allowNull: true,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: IconButton(
                              key: ValueKey(isEditing),
                              onPressed: isEditing
                                  ? _onSavePressed(_formKey, state)
                                  : () => setState(() {
                                      isEditing = true;
                                    }),
                              icon: Icon(
                                isEditing
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.penToSquare,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String username;
  final String email;
  final String? imageUrl;

  const Header({
    super.key,
    required this.username,
    required this.email,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ProfileAvatar(size: 60, imageUrl: imageUrl),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(username), Text(email)],
          ),
        ],
      ),
    );
  }
}
