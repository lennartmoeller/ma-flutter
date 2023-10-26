extension DateTimeExtension on DateTime {
  /// Returns a string representation of the date in the format YYYY-MM-DD.
  String toDateString() => toIso8601String().substring(0, 10);
}
