class Arabic {
  static const List<String> _arabicNumbers = [
    "٠",
    "١",
    "٢",
    "٣",
    "٤",
    "٥",
    "٦",
    "٧",
    "٨",
    "٩"
  ];

  static String numberToArabic(int number) {
    String newString = "";
    List<String> z = number.toString().trim().split('');
    for (String i in z) {
      newString += _arabicNumbers[int.parse(i)];
    }
    return newString;
  }

  static String ayaNumber(int ayaNumber) {
    return '\ufd3f' + numberToArabic(ayaNumber) + '\ufd3e';
  }
}
