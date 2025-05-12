import 'package:intl/intl.dart';

extension StringFormatter on String {
  String toStringFormatDateTime() {
    DateTime date = DateTime.parse(this);
    return DateFormat('d MMMM yyyy HH:mm', 'id_ID').format(date); // Output : 1 Mei 2025 19:00
  }

  // New extension untuk parsing string menjadi DateTime
  DateTime toParsedDateTime() {
    return DateFormat('dd-MM-yyyy HH:mm:ss', 'id_ID').parse(this);
  }
}

extension DateTimeFormatter on DateTime {
  String toDateTimeFormatString() {
    return DateFormat('d MMMM yyyy HH:mm', 'id_ID').format(this); // Output : 1 Mei 2025 19:00
  }
}
