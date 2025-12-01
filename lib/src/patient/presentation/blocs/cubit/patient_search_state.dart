part of 'patient_search_cubit.dart';

enum PatientSearchStatus { initial, loading, loaded, selected, error, notFound }

enum PatientSearchByMode {
  pesel,
  name;

  String translate(BuildContext context) => switch (this) {
    PatientSearchByMode.pesel => "PESEL",
    PatientSearchByMode.name => context.translate.firstName,
  };
}

final class PatientSearchState extends Equatable {
  final PatientSearchStatus status;
  final PatientSearchByMode searchByMode;
  final Patient? selectedPatient;
  final List<Patient> foundPatients;
  final Failure? error;
  const PatientSearchState({
    this.status = PatientSearchStatus.initial,
    this.searchByMode = PatientSearchByMode.pesel,
    this.selectedPatient,
    this.foundPatients = const [],
    this.error,
  });

  const PatientSearchState.empty({
    this.status = PatientSearchStatus.initial,
    this.searchByMode = PatientSearchByMode.pesel,
    this.selectedPatient,
    this.foundPatients = const [],
    this.error,
  });

  PatientSearchState copyWith({
    PatientSearchStatus? status,
    PatientSearchByMode? searchByMode,
    Patient? selectedPatient,
    List<Patient>? foundPatients,
    Failure? error,
  }) {
    var newPatient = selectedPatient;
    if (newPatient == null) {
      newPatient = this.selectedPatient;
    } else if (newPatient == const Patient.empty()) {
      newPatient = null;
    }
    return PatientSearchState(
      status: status ?? this.status,
      searchByMode: searchByMode ?? this.searchByMode,
      selectedPatient: newPatient,
      foundPatients: foundPatients ?? this.foundPatients,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    searchByMode,
    selectedPatient,
    foundPatients,
    error,
  ];
}
