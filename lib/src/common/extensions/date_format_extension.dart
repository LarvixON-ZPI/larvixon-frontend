extension DateFormatExtension on DateTime {
  String get formattedDateOnly {
    return '${day.toString().padLeft(2, '0')}/'
        '${month.toString().padLeft(2, '0')}/'
        '$year';
  }

  String get formattedTimeOnly {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDateOnly $formattedTimeOnly';
  }
}
