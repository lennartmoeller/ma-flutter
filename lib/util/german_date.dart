import 'package:ma_flutter/util/utility.dart';

class GermanDate {
  late final DateTime _dateTime;

  GermanDate(String? str) {
    if (str == null) {
      _dateTime = DateTime.now();
      return;
    }
    if (str.length > 10) {
      str = str.substring(0, 10);
    }
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(str)) {
      throw Exception("Invalid date format. Expected 'YYYY-MM-DD'.");
    }
    _dateTime = DateTime.parse(str);
  }

  @override
  String toString() => _dateTime.toIso8601String().substring(0, 10);

  DateTime toDateTime() => _dateTime;

  int compareTo(GermanDate other) => _dateTime.compareTo(other._dateTime);

  String getMonthName() {
    const monthNames = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember"
    ];
    return monthNames[_dateTime.month - 1];
  }

  String getWeekdayName() {
    const weekdayNames = [
      "Montag",
      "Dienstag",
      "Mittwoch",
      "Donnerstag",
      "Freitag",
      "Samstag",
      "Sonntag"
    ];
    return weekdayNames[_dateTime.weekday - 1];
  }

  String beautifyDate({
    bool monthAsNumber = true,
    bool includeYear = true,
    bool twoDigitNumbers = true,
    bool includeWeekday = false,
  }) {
    return [
      if (includeWeekday) "${getWeekdayName()}, ",
      if (twoDigitNumbers) "${Utility.addLeadingZeros(_dateTime.day, 2)}." else "${_dateTime.day}.",
      if (monthAsNumber)
        if (twoDigitNumbers)
          "${Utility.addLeadingZeros(_dateTime.month, 2)}."
        else
          "${_dateTime.month}."
      else
        " ${getMonthName()}",
      if (includeYear && !monthAsNumber) " ",
      if (includeYear) _dateTime.year,
    ].join();
  }
}
