import 'package:larvixon_frontend/src/common/utils/base_mapper.dart';
import 'package:larvixon_frontend/src/patient/data/models/patient_dto.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

class PatientMapper implements Mapper<PatientDTO, Patient> {
  @override
  Patient dtoToEntity(PatientDTO dto) {
    return Patient(
      id: dto.id,
      firstName: dto.first_name,
      lastName: dto.last_name,
      pesel: dto.pesel,
      birthDate: dto.birth_date != null
          ? DateTime.tryParse(dto.birth_date!)
          : null,
      gender: Gender.fromString(dto.gender),
      phone: dto.phone,
      email: dto.email,
      address: dto.address_line,
      city: dto.city,
      postalCode: dto.postal_code,
      country: dto.country,
    );
  }

  @override
  PatientDTO entityToDto(Patient entity) {
    throw UnimplementedError();
  }
}
