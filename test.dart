class Arabic {
  String numberToArabic(int number) {
    List<String> arabicNumbers = [
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
    List<String> z = number.toString().trim().split('');
    print(z);
    String newString = "";
    for (String i in z) {
      int index = int.parse(i);
      newString += arabicNumbers[index];
    }
    return newString;
  }

  String ayaNumber(String arabicNumber) {
    return ' \ufd3e' + arabicNumber + '\ufd3f ';
  }
}

main() {
  var a = "آل عمران";
  var remove = [
    r"\u0600-\u06FF",
    'ِ',
    'ُ',
    'ٓ',
    'ٰ',
    'ْ',
    'ٌ',
    'ٍ',
    'ً',
    'ّ',
    'َ'
  ];
  Map<String, String> rem2 = {"ٱ": "ا", "آل": "ال"};
  remove.forEach((element) {
    a = a.replaceAll(element, "");
  });
  rem2.forEach((key, value) {
    a = a.replaceAll(key, value);
  });
  print(a.contains("ال"));
}
