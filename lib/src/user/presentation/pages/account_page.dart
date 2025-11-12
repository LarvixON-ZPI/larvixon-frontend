import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';
import 'package:larvixon_frontend/src/user/bloc/user_bloc.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/header_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/basic_info_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/credentials_section.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/details_section.dart';

class AccountPage extends StatelessWidget {
  static const String route = '/account';
  static const String name = 'account';

  const AccountPage({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = AdaptiveFilePicker();
    final result = await picker.pickFile(type: FileType.image);
    if (result != null) {
      context.read<UserEditCubit>().updatePhoto(fileResult: result);
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
                          const HeaderSection(),
                          CustomCard(
                            child: Row(
                              spacing: 16,
                              children: [
                                ProfilePictureSection(
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

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({
    super.key,
    required this.profilePictureUrl,
    this.onTap,
  });

  final String? profilePictureUrl;
  final VoidCallback? onTap;

  bool get hasImage =>
      profilePictureUrl != null && profilePictureUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserEditCubit, UserEditState>(
      builder: (context, state) {
        final isUploading = state.status == EditStatus.uploadingPhoto;

        return InkWell(
          onTap: isUploading ? null : onTap,
          child: CircleAvatar(
            radius: 64,
            backgroundColor: Colors.grey.shade200,
            child: hasImage
                ? ClipOval(
                    child: Image.network(
                      profilePictureUrl!,
                      width: 128,
                      height: 128,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 64,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.person, size: 64, color: Colors.grey),
          ).withOnHoverEffect,
        );
      },
    );
  }
}
