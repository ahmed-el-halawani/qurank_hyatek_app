import 'package:flutter/cupertino.dart';

Size calc(String s, TextStyle textStyle) {
  Size x = (TextPainter(
          text: TextSpan(text: s, style: textStyle),
          maxLines: 1,
          textDirection: TextDirection.rtl)
        ..layout())
      .size;
  return x;
}
