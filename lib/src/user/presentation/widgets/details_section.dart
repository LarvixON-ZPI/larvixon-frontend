import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/field_error_mixin.dart';
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
    with
        FormValidatorsMixin,
        FieldErrorMixin<DetailsSection>,
        FormFieldValidationMixin<DetailsSection> {
  final _formKey = GlobalKey<FormState>();
  late final _phoneController = TextEditingController(text: widget.phoneNumber);
  late final _organizationController = TextEditingController(
    text: widget.organization,
  );
  late final _bioController = TextEditingController(text: widget.bio);
  Timer? _debounce;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _phoneController,
      _organizationController,
      _bioController,
    ]) {
      controller.addListener(_onTextChanged);
    }
    _phoneController.addListener(() => onFieldChanged('phone_number'));
    _organizationController.addListener(() => onFieldChanged('organization'));
    _bioController.addListener(() => onFieldChanged('bio'));
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final changed =
          _phoneController.text != widget.phoneNumber ||
          _organizationController.text != widget.organization ||
          _bioController.text != widget.bio;

      if (changed != _hasChanges) {
        setState(() => _hasChanges = changed);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _phoneController.dispose();
    _organizationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null) return;
    if (form.validate()) {
      form.save();
      context.read<UserEditCubit>().updateDetails(
        phoneNumber: _phoneController.text,
        organization: _organizationController.text,
        bio: _bioController.text,
      );
    }
  }

  bool hasChanges() {
    return _phoneController.text != (widget.phoneNumber ?? '') ||
        _bioController.text != (widget.bio ?? '') ||
        _organizationController.text != (widget.organization ?? '');
  }

  void _reset() {
    _formKey.currentState?.reset();
    _phoneController.text = widget.phoneNumber ?? '';
    _organizationController.text = widget.organization ?? '';
    _bioController.text = widget.bio ?? '';
  }

  @override
  void didUpdateWidget(covariant DetailsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final backendDataChanged =
        widget.phoneNumber != oldWidget.phoneNumber ||
        widget.organization != oldWidget.organization ||
        widget.bio != oldWidget.bio;

    if (backendDataChanged) {
      _phoneController.text = widget.phoneNumber ?? '';
      _organizationController.text = widget.organization ?? '';
      _bioController.text = widget.bio ?? '';

      if (_hasChanges) {
        setState(() => _hasChanges = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: BlocConsumer<UserEditCubit, UserEditState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditStatus.error,
        listener: (context, state) {
          final error = state.error;
          if (error is ValidationFailure && state.fieldErrors.isNotEmpty) {
            setFieldErrors(error.fieldErrors);
            _formKey.currentState?.validate();
          }
        },
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
                            controller: _phoneController,
                            readOnly: isSaving,
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            keyboardType: TextInputType.phone,
                            autovalidateMode: getAutovalidateMode(
                              'phone_number',
                            ),
                            validator: (value) => validateField(
                              context,
                              'phone_number',
                              (context, value) =>
                                  validatePhoneNumber(context, value),
                              value,
                            ),
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
                            controller: _organizationController,
                            readOnly: isSaving,
                            autofillHints: const [
                              AutofillHints.organizationName,
                            ],
                            autovalidateMode: getAutovalidateMode(
                              'organization',
                            ),
                            validator: (value) => validateField(
                              context,
                              'organization',
                              (context, value) => lengthValidator(
                                context,
                                value,
                                fieldName: context.translate.organization,
                                minLength: 0,
                                maxLength: 255,
                                allowNull: true,
                              ),
                              value,
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
                      controller: _bioController,
                      readOnly: isSaving,
                      minLines: 2,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      autovalidateMode: getAutovalidateMode('bio'),
                      validator: (value) => validateField(
                        context,
                        'bio',
                        (context, value) => lengthValidator(
                          context,
                          value,
                          fieldName: context.translate.bio,
                          minLength: 0,
                          maxLength: 500,
                          allowNull: true,
                        ),
                        value,
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
