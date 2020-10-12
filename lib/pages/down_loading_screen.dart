import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/pages/home.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/values/style.dart';
import 'package:quran/widget/loading.dart';
import 'package:quran/widget/responsive_box.dart';

class DownLoadScreen extends StatelessWidget {
  ElsurahProvider prov;

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ElsurahProvider>(context);
    precacheImage(AssetImage("assets/images/card.jpg"), context);
    precacheImage(AssetImage("assets/images/8point_star.png"), context);
    precacheImage(AssetImage("assets/images/left_border.png"), context);
    precacheImage(AssetImage("assets/images/right_border.png"), context);
    precacheImage(AssetImage("assets/images/bottom_border.png"), context);
    precacheImage(AssetImage("assets/images/top_border.png"), context);

    String massage = waitingFor();

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
              "زينوا القرآن بأصواتكم",
              style: MyStyle.generalTextStyle(fontSize: 20).copyWith(
                color: MyColors.backGround,
              ),
            ),
            Container(
              width: MyDimon.width(context),
              height: MyDimon.height(context) * .7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MyDimon.width(context) * .8,
                    height: MyDimon.height(context) * .62,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyColors.backGround,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "هل يجوز قراءة القرآن للتعبد بدون وضوء؟",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: MyStyle.generalTextStyle(),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ResponsiveBox(
                              width: double.infinity,
                              isMultiLine: true,
                              height: MyDimon.height(context) * .5,
                              child: Text(
                                "يجوز قراءة القرآن بدون وضوء؛ إذا كان القارئ حافظًا للقرآن أو لجزء منه ويتلوه بغير مس للمصحف، أما من أراد قراءة النص المكتوب فيمكنه الاستعانة بالأدوات الحديثة كالمصاحف الموجودة على الهاتف المحمول ونحوها",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: MyStyle.generalTextStyle(),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        (prov.allDone)
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (prov.allDone)
                                      ? Colors.transparent
                                      : Colors.purple,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      massage,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: Fonts.elMessiri),
                                    ),
                                    (prov.allDone)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Loading(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 2,
                        ),
                        RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          constraints: BoxConstraints(
                            minWidth: MyDimon.width(context) * .4,
                            minHeight: MyDimon.height(context) * .08,
                          ),
                          fillColor: (prov.allDone)
                              ? Color(0xfff9b090)
                              : Color(0xffe7e7e7),
                          highlightColor: Colors.black,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 30),
                          onPressed: prov.allDone
                              ? () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) => Home()))
                              : null,
                          child: Text("أبدا القرأة"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  String waitingFor() {
    if (!prov.isDownloadDone()) {
      return "جاري تحميل الملفات";
    } else if (prov.getList().isEmpty) {
      return "جاري تحضير سور القران";
    } else if (prov.getSavedSoraReady() == null) {
      return "جاري تحديد اخر صور قمت بزيارتها";
    } else {
      prov.allDone = true;
      return "";
    }
  }
}
