import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/core/constants/endpoints_patient.dart';
import 'package:larvixon_frontend/src/patient/data/models/patient_dto.dart';

class PatientsDatasource {
  final ApiClient apiClient;

  PatientsDatasource(this.apiClient);

  Future<List<PatientDTO>> searchByPesel({required String pesel}) async {
    final queryParameters = <String, dynamic>{'pesel': pesel};
    final response = await apiClient.dio.get(
      PatientEndpoints.patients,
      queryParameters: queryParameters,
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PatientDTO.fromMap(json)).toList();
  }

  Future<List<PatientDTO>> searchByName({
    required String firstName,
    required String lastName,
  }) async {
    final queryParameters = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
    };
    final response = await apiClient.dio.get(
      PatientEndpoints.patients,
      queryParameters: queryParameters,
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PatientDTO.fromMap(json)).toList();
  }

  Map<String, dynamic> searchById({required String id}) {
    throw UnimplementedError();
  }
}
// final queryParameters = <String, dynamic>{};
// if (sort != null) {
//   queryParameters['ordering'] = sort.toQueryParam();
// }
// if (filter != null) {
//   final status = filter.status;
//   if (status != null) {
//     queryParameters['status'] = status.name;
//   }
//   final createdAtRange = filter.createAtDateRange;
//   if (createdAtRange != null) {
//     String formatDate(DateTime d) =>
//         "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

//     final createdAtStart = createdAtRange.start;
//     final createdAtEnd = createdAtRange.end;
//     queryParameters['created_at__date__gte'] = formatDate(createdAtStart);
//     queryParameters['created_at__date__lte'] = formatDate(createdAtEnd);
//   }
// }

// if (nextPage != null) {
//   final response = await apiClient.dio.get(nextPage);
//   return AnalysisIdListDTO.fromMap(response.data);
// }
// final response = await apiClient.dio.get(
//   AnalysisEndpoints.videoIDs,
//   queryParameters: queryParameters,
// );
// return AnalysisIdListDTO.fromMap(response.data);
