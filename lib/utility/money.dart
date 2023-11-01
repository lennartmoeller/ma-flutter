import 'package:intl/intl.dart';

class Money {
  static NumberFormat formatter = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 2,
  );

  static String format(int cents) {
    return formatter.format(cents / 100);
  }
}
