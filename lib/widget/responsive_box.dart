import 'package:flutter/cupertino.dart';
import 'package:quran/values/style.dart';

class ResponsiveBox extends StatelessWidget {
  final double width;
  final double height;
  final Text child;
  final bool isMultiLine;

  const ResponsiveBox(
      {this.width, this.height = 20, this.child, this.isMultiLine = false});

  @override
  Widget build(BuildContext context) {
    return isMultiLine
        ? multiLineResizerText(child.data, child.style)
        : resizeText(child.data, child.style);
  }

  Text multiLineResizerText(String text, TextStyle style) {
    TextStyle myStyle = style;
    if (style == null) {
      myStyle = MyStyle.largText;
    }
    TextPainter z = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.rtl,
        maxLines: 1)
      ..layout();
    int maxLinex = (z.size.width / width).toInt();
    int availableLines = (height / z.size.height).toInt();
    if (maxLinex > availableLines) {
      return resizeText(text, myStyle.copyWith(fontSize: style.fontSize - 5));
    } else {
      return Text(
        text,
        style: style,
        textDirection: child.textDirection,
        textAlign: child.textAlign,
      );
    }
  }

  Text resizeText(String text, TextStyle style) {
    TextStyle myStyle = style;
    if (style == null) {
      myStyle = MyStyle.largText;
    }
    TextPainter z = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.rtl,
        maxLines: 1)
      ..layout();
    if (z.size.width > width || z.size.height > height) {
      return resizeText(text, myStyle.copyWith(fontSize: style.fontSize - 5));
    } else {
      return Text(
        text,
        style: style,
      );
    }
  }
}
