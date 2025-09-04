import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/extensions/translate_extension.dart';

import '../bloc/user_bloc.dart';
import '../user.dart';

class AccountPage extends StatefulWidget {
  static final String route = '/account';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.account),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                _setupControllers(user: context.read<UserBloc>().state.user);
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
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

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Header(username: user.username, email: user.email),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 10.0,
                          children: [
                            TextFormField(
                              readOnly: !isEditing,
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: context.translate.firstName,
                              ),
                            ),
                            TextFormField(
                              readOnly: !isEditing,

                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: context.translate.lastName,
                              ),
                            ),
                            TextFormField(
                              readOnly: !isEditing,

                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                labelText: context.translate.phoneNumber,
                              ),
                            ),
                            TextFormField(
                              readOnly: !isEditing,

                              controller: _organizationController,
                              decoration: InputDecoration(
                                labelText: context.translate.organization,
                              ),
                            ),
                            TextFormField(
                              readOnly: !isEditing,

                              controller: _bioController,
                              decoration: InputDecoration(
                                labelText: context.translate.bio,
                              ),
                            ),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                final offset = Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation);
                                return SlideTransition(
                                  position: offset,
                                  child: child,
                                );
                              },
                              child: isEditing
                                  ? ElevatedButton(
                                      onPressed: state.isUpdating
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<UserBloc>().add(
                                                  UserProfileDataUpdateRequested(
                                                    firstName:
                                                        _firstNameController
                                                            .text,
                                                    lastName:
                                                        _lastNameController
                                                            .text,
                                                    bio: _bioController.text,
                                                    phoneNumber:
                                                        _phoneNumberController
                                                            .text,
                                                    organization:
                                                        _organizationController
                                                            .text,
                                                  ),
                                                );
                                                setState(() {
                                                  isEditing = false;
                                                });
                                              }
                                            },
                                      child: Text(context.translate.save),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String username;
  final String email;

  const Header({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              username.isNotEmpty ? username[0] : '',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
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
