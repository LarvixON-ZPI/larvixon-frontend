import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';
import 'package:larvixon_frontend/src/patient/presentation/blocs/cubit/patient_search_cubit.dart';

class PatientSearch extends StatefulWidget {
  const PatientSearch({super.key});

  @override
  State<PatientSearch> createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch>
    with FormValidatorsMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _peselController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientSearchCubit, PatientSearchState>(
      builder: (context, state) {
        final searchMode = state.searchByMode;
        final selectedPatient = state.selectedPatient;
        final colors = Theme.of(context).colorScheme;
        return Column(
          spacing: 16,
          children: [
            Row(
              spacing: 16,
              children: PatientSearchByMode.values.map((mode) {
                return Expanded(
                  child: ElevatedButton(
                    style: searchMode == mode
                        ? ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                          )
                        : ElevatedButton.styleFrom(
                            backgroundColor: colors.surfaceContainerHighest,
                            foregroundColor: colors.onSurfaceVariant,
                          ),
                    onPressed: () {
                      _formKey.currentState?.reset();
                      context.read<PatientSearchCubit>().setMode(mode: mode);
                    },
                    child: Text(mode.translate(context)),
                  ),
                );
              }).toList(),
            ),
            Form(
              key: _formKey,
              child: Column(
                spacing: 8,
                children: searchMode == PatientSearchByMode.name
                    ? [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            hintText: context.translate.firstName,
                          ),
                          validator: (value) =>
                              firstNameValidator(context, value),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            hintText: context.translate.lastName,
                          ),
                          validator: (value) =>
                              lastNameValidator(context, value),
                        ),
                      ]
                    : [
                        TextFormField(
                          controller: _peselController,
                          decoration: const InputDecoration(hintText: "PESEL"),
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              peselValidator(context, value, true),
                        ),
                      ],
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                switch (searchMode) {
                  case PatientSearchByMode.pesel:
                    context.read<PatientSearchCubit>().searchByPesel(
                      pesel: _peselController.text,
                    );
                  case PatientSearchByMode.name:
                    context.read<PatientSearchCubit>().searchByName(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                    );
                }
              },
              label: Text(
                state.status == PatientSearchStatus.loading
                    ? context.translate.loading
                    : context.translate.search,
              ),
            ),

            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _SearchResults(state: state),
              ),
            ),
            if (selectedPatient != null &&
                selectedPatient != const Patient.empty()) ...[
              const Divider(),
              Column(
                spacing: 8,
                children: [
                  Text(
                    context.translate.selectedPatient,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  _PatientEntry(
                    selected: true,
                    patient: selectedPatient,
                    colors: colors,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.state});

  final PatientSearchState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      PatientSearchStatus.notFound => const _NotFoundState(
        key: ValueKey('not-found'),
      ),
      PatientSearchStatus.error => _ErrorState(
        key: const ValueKey('error'),
        error: state.error,
      ),
      PatientSearchStatus.loaded => _PatientList(
        key: const ValueKey('patient-list'),
        state: state,
      ),
      _ =>
        state.foundPatients.isNotEmpty
            ? _PatientList(key: const ValueKey('patient-list'), state: state)
            : const SizedBox.shrink(),
    };
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.search_off, size: 48, color: colors.onSurfaceVariant),
        const SizedBox(height: 8),
        Text(
          context.translate.patientsNotFound,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({super.key, this.error});

  final Failure? error;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final errorMessage = error?.message ?? context.translate.unknownError;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: colors.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientList extends StatelessWidget {
  const _PatientList({super.key, required this.state});

  final PatientSearchState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),

      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.foundPatients.length,

        itemBuilder: (context, index) {
          final patient = state.foundPatients[index];
          final selected = patient == state.selectedPatient;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: _PatientEntry(
              selected: selected,
              patient: patient,
              colors: colors,
            ),
          );
        },
      ),
    );
  }
}

class _PatientEntry extends StatelessWidget {
  const _PatientEntry({
    required this.selected,
    required this.patient,
    required this.colors,
  });

  final bool selected;
  final Patient patient;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        selected
            ? context.read<PatientSearchCubit>().unselectPatient()
            : context.read<PatientSearchCubit>().selectPatient(
                patient: patient,
              );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? colors.primaryContainer
              : colors.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    "${patient.firstName} ${patient.lastName}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                    ),
                  ),
                  if (patient.pesel != null)
                    Text(
                      "PESEL: ${patient.pesel}",
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? colors.onPrimaryContainer.withValues(alpha: 0.8)
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    "ID: ${patient.id}",
                    style: TextStyle(
                      fontSize: 14,
                      color: selected
                          ? colors.onPrimaryContainer.withValues(alpha: 0.8)
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: colors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
