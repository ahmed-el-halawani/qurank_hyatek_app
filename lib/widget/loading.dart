import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';

class Loading extends StatelessWidget {
  final Color color;

  Loading({this.color = MyColors.selectedTabColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SpinKitFadingCube(
        color: color,
        size: 20.0,
      ),
    );
  }
}
