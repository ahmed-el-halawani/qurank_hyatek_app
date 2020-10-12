import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/constProvider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/pages/down_loading_screen.dart';
import 'package:quran/pages/home.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/values/style.dart';
import 'package:quran/widget/loading.dart';
import 'package:quran/widget/responsive_box.dart';

class ThemeChanger extends StatelessWidget {
  ConstProvider cProv;

  @override
  Widget build(BuildContext context) {
    cProv = Provider.of<ConstProvider>(context);

    return Scaffold(
        body: SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "قرانك حياتك",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: MyColors.backGround,
                  fontFamily: Fonts.elMessiri),
            ),
            Text(
              "اختر الشكل الذي يريحك",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: MyColors.backGround,
                  fontFamily: Fonts.elMessiri),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MyDimon.width(context) * .4,
                  height: MyDimon.height(context) * .45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MyDimon.width(context) * .4,
                        height: MyDimon.height(context) * .45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColors.backGround,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/images/classic.png")),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: RawMaterialButton(
                          onPressed: () {
                            cProv.changeTheme(themeSelectKey.classicTheme);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DownLoadScreen(),
                                ));
                          },
                          constraints: BoxConstraints(
                            minWidth: MyDimon.width(context) * .5,
                            minHeight: MyDimon.height(context) * .04,
                          ),
                          fillColor: Color(0xfff9b090),
                          highlightColor: Colors.black,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 30),
                          child: Text("الكلاسيكي"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MyDimon.width(context) * .4,
                  height: MyDimon.height(context) * .45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MyDimon.width(context) * .4,
                        height: MyDimon.height(context) * .45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColors.backGround,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/images/modern.png")),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: RawMaterialButton(
                          onPressed: () {
                            cProv.changeTheme(themeSelectKey.modernTheme);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DownLoadScreen(),
                                ));
                          },
                          constraints: BoxConstraints(
                            minWidth: MyDimon.width(context) * .5,
                            minHeight: MyDimon.height(context) * .04,
                          ),
                          fillColor: Color(0xfff9b090),
                          highlightColor: Colors.black,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 30),
                          child: Text("حديث"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
