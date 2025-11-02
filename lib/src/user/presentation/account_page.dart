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
import 'package:larvixon_frontend/src/user/presentation/widgets/basic_info_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/credentials_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/details_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/actions_section.dart';

class AccountPage extends StatelessWidget {
  static const String route = '/account';
  static const String name = 'account';

  const AccountPage({super.key});

  Future<void> _pickImage(BuildContext context) async {
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
                            children: [Expanded(child: ActionsSection())],
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
                          CredentialsSection(
                            direction: direction,
                            username: user.username,
                            email: user.email,
                          ),

                          BasicInfoSection(
                            direction: direction,
                            email: user.email,
                            firstName: user.firstName ?? "",
                            lastName: user.lastName ?? "",
                            username: user.username,
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
  bool get hasImage => profilePictureUrl != null;

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
