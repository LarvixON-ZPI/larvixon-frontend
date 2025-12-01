import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';
import 'package:larvixon_frontend/src/patient/domain/repositories/patient_repository.dart';

class PatientRepositoryFake implements PatientRepository {
  // Mock database of 10 patients
  static final List<Patient> mockPatients = [
    const Patient(
      id: '1',
      pesel: '85010112345',
      firstName: 'Jan',
      lastName: 'Kowalski',
    ),
    const Patient(
      id: '2',
      pesel: '90021523456',
      firstName: 'Anna',
      lastName: 'Nowak',
    ),
    const Patient(
      id: '3',
      pesel: '78030334567',
      firstName: 'Piotr',
      lastName: 'Wiśniewski',
    ),
    const Patient(
      id: '4',
      pesel: '92041145678',
      firstName: 'Maria',
      lastName: 'Wójcik',
    ),
    const Patient(
      id: '5',
      pesel: '88052256789',
      firstName: 'Tomasz',
      lastName: 'Kamiński',
    ),
    const Patient(
      id: '6',
      pesel: '95060867890',
      firstName: 'Katarzyna',
      lastName: 'Lewandowska',
    ),
    const Patient(
      id: '7',
      pesel: '82071278901',
      firstName: 'Michał',
      lastName: 'Zieliński',
    ),
    const Patient(
      id: '8',
      pesel: '91082589012',
      firstName: 'Magdalena',
      lastName: 'Szymańska',
    ),
    const Patient(
      id: '9',
      pesel: '87093090123',
      firstName: 'Krzysztof',
      lastName: 'Woźniak',
    ),
    const Patient(
      id: '10',
      pesel: '93101801234',
      firstName: 'Agnieszka',
      lastName: 'Dąbrowska',
    ),
  ];

  @override
  TaskEither<Failure, Patient?> searchById({required String id}) {
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(const Duration(milliseconds: 300));
        return mockPatients.firstWhere((patient) => patient.id == id);
      },
      (error, stackTrace) => Failure(message: 'Patient with ID $id not found'),
    );
  }

  @override
  TaskEither<Failure, List<Patient>> searchByName({
    required String firstName,
    required String lastName,
  }) {
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(const Duration(milliseconds: 500));

        final results = mockPatients.where((patient) {
          final firstNameMatch = patient.firstName?.toLowerCase().contains(
            firstName.toLowerCase(),
          );
          final lastNameMatch = patient.lastName?.toLowerCase().contains(
            lastName.toLowerCase(),
          );
          if (firstNameMatch == null) return false;
          if (lastNameMatch == null) return false;

          return firstNameMatch && lastNameMatch;
        }).toList();

        return results;
      },
      (error, stackTrace) =>
          Failure(message: 'No patients found with name: $firstName $lastName'),
    );
  }

  @override
  TaskEither<Failure, List<Patient>> searchByPesel({required String pesel}) {
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(const Duration(milliseconds: 400));

        final results = mockPatients.where((patient) {
          return patient.pesel == pesel;
        }).toList();

        if (results.isEmpty) {
          throw Exception('Patient not found');
        }

        return results;
      },
      (error, stackTrace) {
        if (error.toString().contains('Invalid PESEL')) {
          return const Failure(
            message: 'Invalid PESEL format. Must be 11 digits.',
          );
        }
        return Failure(message: 'No patient found with PESEL: $pesel');
      },
    );
  }
}
