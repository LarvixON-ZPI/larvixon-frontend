import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';

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

  void _submitForm(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null) return;
    if (form.validate()) {
      form.save();
      context.read<UserEditCubit>().updateDetails(
        phoneNumber: phoneController.text,
        organization: organizationController.text,
        bio: bioController.text,
      );
    }
  }

  bool hasChanges() {
    return phoneController.text != (widget.phoneNumber ?? '') ||
        bioController.text != (widget.bio ?? '') ||
        organizationController.text != (widget.organization ?? '');
  }

  void _reset() {
    _formKey.currentState?.reset();
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
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                validatePhoneNumber(context, value),
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
                                    onPressed: _reset,
                                    child: Text(context.translate.cancel),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: canSave
                                        ? () => _submitForm(context)
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
