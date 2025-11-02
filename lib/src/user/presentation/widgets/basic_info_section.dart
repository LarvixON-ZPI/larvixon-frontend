import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';

class BasicInfoSection extends StatefulWidget {
  const BasicInfoSection({
    super.key,
    required this.direction,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;

  final Axis direction;

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection>
    with FormValidatorsMixin {
  final _formKey = GlobalKey<FormState>();
  late final firstNameController = TextEditingController(
    text: widget.firstName,
  );
  late final lastNameController = TextEditingController(text: widget.lastName);
  Timer? _debounce;
  bool _hasChanges = false;
  @override
  void initState() {
    super.initState();
    for (final controller in [firstNameController, lastNameController]) {
      controller.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final changed =
          firstNameController.text != widget.firstName ||
          lastNameController.text != widget.lastName;

      if (changed != _hasChanges) {
        setState(() => _hasChanges = changed);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return firstNameController.text != widget.firstName ||
        lastNameController.text != widget.lastName;
  }

  void reset() {
    _formKey.currentState?.reset();
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
  }

  @override
  void didUpdateWidget(covariant BasicInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final backendDataChanged =
        widget.firstName != oldWidget.firstName ||
        widget.lastName != oldWidget.lastName;

    if (backendDataChanged) {
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  direction: widget.direction,
                  children: [
                    Flexible(
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.firstName),
                          TextFormField(
                            controller: firstNameController,
                            validator: (value) =>
                                firstNameValidator(context, value),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.lastName),
                          TextFormField(
                            controller: lastNameController,
                            validator: (value) =>
                                lastNameValidator(context, value),
                          ),
                        ],
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

  void _submitForm(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null) return;
    if (form.validate()) {
      form.save();
      context.read<UserEditCubit>().updateBasicInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );
    }
  }
}
