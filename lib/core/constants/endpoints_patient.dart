import 'package:larvixon_frontend/core/constants/api_base.dart';

class PatientEndpoints {
  static const String patients = '${ApiBase.baseUrl}/patients/';
  static String patientById(String id) => '${ApiBase.baseUrl}/patients/$id/';
}
