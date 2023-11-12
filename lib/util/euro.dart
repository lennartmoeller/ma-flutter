import 'package:intl/intl.dart';

class Euro {
  static NumberFormat formatter = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 2,
  );

  static String toStr(int cents, {bool includeEuroSign = true, bool includeDots = true}) {
    String str = formatter.format(cents / 100);
    if (includeEuroSign == false) str = str.substring(0, str.length - 2);
    if (includeDots == false) str = str.replaceAll('.', '');
    return str;
  }

  static int? toCent(String formattedString) {
    String numberString = formattedString
        .replaceAll(' ', '')
        .replaceAll('€', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    if (numberString == "") {
      return 0;
    }
    double? euroDouble = double.tryParse(numberString);
    if (euroDouble == null) {
      return null;
    }
    return (euroDouble * 100).round();
  }
}
