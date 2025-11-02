import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/profile_avatar.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';
import 'package:larvixon_frontend/src/user/bloc/user_bloc.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';

class AccountPage extends StatelessWidget {
  static const String route = '/account';
  static const String name = 'account';

  const AccountPage({super.key});

  Future<FilePickResult?> _pickImage(BuildContext context) async {
    final picker = AdaptiveFilePicker();
    final result = await picker.pickFile(type: FileType.image);
    if (result != null) {
      context.read<UserEditCubit>().updatePhoto(
        bytes: result.bytes,
        fileName: result.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: BlocProvider(
              create: (context) =>
                  UserEditCubit(repository: context.read<UserRepository>()),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  final user = state.user;
                  final profilePictureUrl = user.profilePictureUrl;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isVertical =
                          constraints.maxWidth < Breakpoints.small;
                      final direction = isVertical
                          ? Axis.vertical
                          : Axis.horizontal;

                      return Column(
                        children: [
                          const Row(
                            children: [Expanded(child: HeaderSection())],
                          ),
                          CustomCard(
                            child: Row(
                              spacing: 16,
                              children: [
                                ProfilePicutreSection(
                                  profilePictureUrl: profilePictureUrl,
                                  onTap: () => _pickImage(context),
                                ),
                                Column(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      "${user.firstName} ${user.lastName}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall,
                                    ),
                                    SelectableText(
                                      user.email,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomCard(
                            child: Column(
                              spacing: 16,
                              children: [
                                Flex(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 16,
                                  direction: direction,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        spacing: 2,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(context.translate.firstName),
                                          TextFormField(
                                            initialValue: user.firstName,
                                            readOnly: true,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        spacing: 2,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(context.translate.lastName),
                                          TextFormField(
                                            initialValue: user.lastName,
                                            readOnly: true,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Flex(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 16,
                                  direction: direction,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        spacing: 2,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(context.translate.username),
                                          TextFormField(
                                            initialValue: user.username,
                                            readOnly: true,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        spacing: 2,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(context.translate.email),
                                          TextFormField(
                                            initialValue: user.email,
                                            readOnly: true,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          DetailsSection(
                            direction: direction,
                            bio: user.bio,
                            phoneNumber: user.phoneNumber,
                            organization: user.organization,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget adaptiveFlexChild({required bool isVertical, required Widget child}) {
    return isVertical ? child : Expanded(child: child);
  }
}

class ProfilePicutreSection extends StatelessWidget {
  const ProfilePicutreSection({
    super.key,
    required this.profilePictureUrl,
    this.onTap,
  });

  final String? profilePictureUrl;
  final VoidCallback? onTap;
  get hasImage => profilePictureUrl != null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserEditCubit, UserEditState>(
      builder: (context, state) {
        final isUploading = state.status == EditStatus.uploadingPhoto;
        return InkWell(
          onTap: isUploading ? null : onTap,
          child: CircleAvatar(
            radius: 64,
            backgroundImage: hasImage ? NetworkImage(profilePictureUrl!) : null,
            child: hasImage
                ? null
                : Icon(Icons.person, size: 64, color: Colors.grey),
          ).withOnHoverEffect,
        );
      },
    );
  }
}

class DetailsSection extends StatefulWidget {
  const DetailsSection({
    super.key,
    required this.direction,
    this.organization,
    this.phoneNumber,
    this.bio,
  });

  final Axis direction;
  final String? organization;
  final String? phoneNumber;
  final String? bio;

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection>
    with FormValidatorsMixin {
  final _formKey = GlobalKey<FormState>();
  late final phoneController = TextEditingController(text: widget.phoneNumber);
  late final organizationController = TextEditingController(
    text: widget.organization,
  );
  late final bioController = TextEditingController(text: widget.bio);
  Timer? _debounce;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      phoneController,
      organizationController,
      bioController,
    ]) {
      controller.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final changed =
          phoneController.text != widget.phoneNumber ||
          organizationController.text != widget.organization ||
          bioController.text != widget.bio;

      if (changed != _hasChanges) {
        setState(() => _hasChanges = changed);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    phoneController.dispose();
    organizationController.dispose();
    bioController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return phoneController.text != (widget.phoneNumber ?? '') ||
        bioController.text != (widget.bio ?? '') ||
        organizationController.text != (widget.organization ?? '');
  }

  void reset() {
    phoneController.text = widget.phoneNumber ?? '';
    organizationController.text = widget.organization ?? '';
    bioController.text = widget.bio ?? '';
  }

  @override
  void didUpdateWidget(covariant DetailsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final backendDataChanged =
        widget.phoneNumber != oldWidget.phoneNumber ||
        widget.organization != oldWidget.organization ||
        widget.bio != oldWidget.bio;

    if (backendDataChanged) {
      phoneController.text = widget.phoneNumber ?? '';
      organizationController.text = widget.organization ?? '';
      bioController.text = widget.bio ?? '';

      if (_hasChanges) {
        setState(() => _hasChanges = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: BlocBuilder<UserEditCubit, UserEditState>(
        builder: (context, state) {
          final isSaving = state.status == EditStatus.saving;
          final canSave = !isSaving && _hasChanges;
          return Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                Flex(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: widget.direction,
                  children: [
                    Flexible(
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(context.translate.phoneNumber),
                          TextFormField(
                            controller: phoneController,
                            readOnly: isSaving,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.organization),
                          TextFormField(
                            controller: organizationController,
                            readOnly: isSaving,
                            validator: (value) => lengthValidator(
                              context,
                              value,
                              fieldName: context.translate.organization,
                              minLength: 0,
                              maxLength: 255,
                              allowNull: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.translate.bio),
                    TextFormField(
                      controller: bioController,
                      readOnly: isSaving,
                      validator: (value) => lengthValidator(
                        context,
                        value,
                        fieldName: context.translate.bio,
                        minLength: 0,
                        maxLength: 500,
                        allowNull: true,
                      ),
                    ),
                  ],
                ),
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 150),
                    reverseDuration: const Duration(milliseconds: 150),
                    alignment: Alignment.bottomCenter,
                    curve: Curves.easeInOut,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      reverseDuration: const Duration(milliseconds: 150),
                      transitionBuilder: (child, animation) => SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, -0.1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: _hasChanges
                          ? Row(
                              key: const ValueKey("SaveCancelButtons"),
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: reset,
                                    child: Text(context.translate.cancel),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: canSave
                                        ? () {
                                            final form = _formKey.currentState!;
                                            if (form.validate()) {
                                              form.save();
                                              context
                                                  .read<UserEditCubit>()
                                                  .updateDetails(
                                                    phoneNumber:
                                                        phoneController.text,
                                                    organization:
                                                        organizationController
                                                            .text,
                                                    bio: bioController.text,
                                                  );
                                            }
                                          }
                                        : null,
                                    child: Text(context.translate.save),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(
                              key: ValueKey("CollapsedButtons"),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: IconButton(
        onPressed: () {},
        icon: const Icon(FontAwesomeIcons.penToSquare),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: IconButton(
        tooltip: context.translate.back,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AnalysesOverviewPage.route);
          }
        },
        icon: const Icon(FontAwesomeIcons.arrowLeft),
      ),
    );
  }
}

extension on Axis {
  Axis reverse() {
    return this == Axis.horizontal ? Axis.vertical : Axis.horizontal;
  }
}
