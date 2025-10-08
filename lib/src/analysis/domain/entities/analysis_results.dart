typedef AnalysisResults = List<(String substance, double confidence)>;

extension AnalysisResultsMapper on AnalysisResults {
  static AnalysisResults fromMap(List<dynamic> list) {
    final results = list.map((e) {
      print(e.runtimeType);
      if (e is! Map<String, dynamic>) {
        throw FormatException('Invalid substance entry: $e');
      }
      final substanceMap = e["substance"];
      final confidenceScore = e["confidence_score"] / 100;

      return (substanceMap["name_en"] as String, confidenceScore as double);
    }).toList();

    return results;
  }
}
