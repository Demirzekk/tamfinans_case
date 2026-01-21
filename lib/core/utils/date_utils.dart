import 'package:intl/intl.dart';

class DateUtils {
  DateUtils._();

  static final DateFormat _displayFormat = DateFormat('dd MMMM yyyy', 'tr_TR');
  static final DateFormat _shortFormat = DateFormat('dd', 'tr_TR');
  static final DateFormat _dayNameFormat = DateFormat('EEE', 'tr_TR');

  static String formatDisplayDate(DateTime date) {
    return _displayFormat.format(date);
  }

  static String formatShortDay(DateTime date) {
    return _shortFormat.format(date);
  }

  static String formatDayName(DateTime date) {
    return _dayNameFormat.format(date);
  }

  static bool isWeekday(DateTime date) {
    return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
  }

  static DateTime findLastBusinessDay(DateTime date) {
    DateTime result = date;
    while (!isWeekday(result)) {
      result = result.subtract(const Duration(days: 1));
    }
    return result;
  }

  static List<DateTime> generateDateRange(
    DateTime centerDate, {
    int range = 3,
  }) {
    final List<DateTime> dates = [];

    for (int i = -range; i <= range; i++) {
      dates.add(centerDate.add(Duration(days: i)));
    }

    return dates;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
