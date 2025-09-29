// ignore_for_file: public_member_api_docs, sort_constructors_first

typedef AnalysisResults = List<(String substance, double confidence)>;

extension AnalysisResultsMapper on AnalysisResults {
  static AnalysisResults fromMap(List<dynamic> list) {
    final results = list.map((e) {
      if (e is! List<dynamic> || e.length != 2) {
        throw FormatException('Invalid substance entry: $e');
      }
      final [substance as String, confidence as double] = e;

      return (substance, confidence);
    }).toList();

    return results;
  }
}
