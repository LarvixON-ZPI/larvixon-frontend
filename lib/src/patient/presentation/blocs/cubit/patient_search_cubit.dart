import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';
import 'package:larvixon_frontend/src/patient/domain/repositories/patient_repository.dart';

part 'patient_search_state.dart';

class PatientSearchCubit extends Cubit<PatientSearchState> {
  final PatientRepository repository;
  PatientSearchCubit({required this.repository})
    : super(const PatientSearchState.empty());

  void setMode({required PatientSearchByMode mode}) =>
      emit(state.copyWith(searchByMode: mode));

  Future<void> searchByPesel({required String pesel}) async {
    final result = await repository.searchByPesel(pesel: pesel).run();
    emit(state.copyWith(status: PatientSearchStatus.loading));

    result.match(
      (failure) {
        emit(state.copyWith(error: failure, status: PatientSearchStatus.error));
      },
      (patients) {
        if (patients.isEmpty) {
          return emit(
            state.copyWith(
              status: PatientSearchStatus.notFound,
              foundPatients: patients,
            ),
          );
        }
        emit(
          state.copyWith(
            foundPatients: patients,
            status: PatientSearchStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> searchByName({
    required String firstName,
    required String lastName,
  }) async {
    emit(state.copyWith(status: PatientSearchStatus.loading));
    final result = await repository
        .searchByName(firstName: firstName, lastName: lastName)
        .run();
    result.match(
      (failure) {
        emit(state.copyWith(error: failure, status: PatientSearchStatus.error));
      },
      (patients) {
        if (patients.isEmpty) {
          return emit(
            state.copyWith(
              status: PatientSearchStatus.notFound,
              foundPatients: patients,
            ),
          );
        }
        emit(
          state.copyWith(
            foundPatients: patients,
            status: PatientSearchStatus.loaded,
          ),
        );
      },
    );
  }

  void selectPatient({required Patient patient}) {
    emit(state.copyWith(selectedPatient: patient));
  }

  void unselectPatient() {
    emit(state.copyWith(selectedPatient: const Patient.empty()));
  }
}
