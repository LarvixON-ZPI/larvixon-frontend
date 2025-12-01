import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

abstract class PatientRepository {
  TaskEither<Failure, List<Patient>> searchByPesel({required String pesel});
  TaskEither<Failure, List<Patient>> searchByName({
    required String firstName,
    required String lastName,
  });
  TaskEither<Failure, Patient?> searchById({required String id});
}
