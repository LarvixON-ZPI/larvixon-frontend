import 'package:dio/dio.dart';
import 'package:fpdart/src/task_either.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';

import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/patient/data/datasources/patients_datasource.dart';
import 'package:larvixon_frontend/src/patient/data/mappers/patient_mapper.dart';

import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

import 'package:larvixon_frontend/src/patient/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientsDatasource dataSource;
  final PatientMapper _patientMapper = PatientMapper();

  PatientRepositoryImpl({required this.dataSource});

  @override
  TaskEither<Failure, Patient?> searchById({required String id}) {
    throw UnimplementedError();
  }

  @override
  TaskEither<Failure, List<Patient>> searchByName({
    required String firstName,
    required String lastName,
  }) {
    return TaskEither.tryCatch(
      () async {
        final result = await dataSource.searchByName(
          firstName: firstName,
          lastName: lastName,
        );
        return result.map((dto) => _patientMapper.dtoToEntity(dto)).toList();
      },
      (e, stackTrace) {
        return e is DioException
            ? e.toApiFailure()
            : UnknownApiFailure(statusCode: 0, message: e.toString());
      },
    );
  }

  @override
  TaskEither<Failure, List<Patient>> searchByPesel({required String pesel}) {
    return TaskEither.tryCatch(
      () async {
        final result = await dataSource.searchByPesel(pesel: pesel);
        return result.map((dto) => _patientMapper.dtoToEntity(dto)).toList();
      },
      (e, stackTrace) {
        return e is DioException
            ? e.toApiFailure()
            : UnknownApiFailure(statusCode: 0, message: e.toString());
      },
    );
  }
}
