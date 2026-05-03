import 'package:intl/intl.dart';

class AppDateFormatter {
  AppDateFormatter._();

  static String fullDate(DateTime date) {
    try {
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('EEEE, d MMMM yyyy').format(date);
    }
  }

  static String shortDate(DateTime date) {
    try {
      return DateFormat('d MMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy').format(date);
    }
  }

  static String dateTime(DateTime date) {
    try {
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy, HH:mm').format(date);
    }
  }

  static String monthYear(DateTime date) {
    try {
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('MMMM yyyy').format(date);
    }
  }
}
