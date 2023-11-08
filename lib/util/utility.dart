class Utility {
  static String addLeadingZeros(int number, int length) {
    String numberStr = number.toString();
    if (numberStr.length > length) {
      throw Exception("Length is smaller than the string representation of amount.");
    }
    return numberStr.padLeft(length, '0');
  }
}
