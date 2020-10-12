import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/controller/viewProvider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/pages/reading_and_listen.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/extentions.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/values/style.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class ReadingScreen2 extends StatelessWidget {
  final SurahsModel sora;
  ElsurahProvider prov;
  ViewProvider vProv;
  ScrollController cont;
  bool firstOpen = true;
  int pageIndex = 0;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;
  StreamSubscription stre;
  bool isSt = false;

  ReadingScreen2(this.sora);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    prov = Provider.of<ElsurahProvider>(context);
    vProv = Provider.of<ViewProvider>(context);
    if (firstOpen) {
      firstOpen = false;
      prov.prepareSoraWithData(sora);
    }
    pageController = PageController(initialPage: prov.pageNumber - 1);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: quranPageBuilder(context),
    );
  }

  quranPageBuilder(BuildContext context) {
    int indexes = sora.getPagesIndexes();
    double pageBarWidth = (MyDimon.width(context) / (indexes + 1)) - 3;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: Container(
                color: MyColors.backGround,
                height: 2,
                width: MyDimon.width(context),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: MyColors.iconColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            shadowColor: MyColors.backGround,
            centerTitle: true,
            toolbarHeight: vProv.appBarHeight,
            backgroundColor: MyColors.backGround,
            elevation: 0,
            title: Text(
              sora.soraTitle,
              style: TextStyle(
                fontFamily: Fonts.elquran,
                fontSize: 50,
              ),
            ),
          ),
          body: Container(
            color: Colors.lightBlueAccent.withAlpha(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                pageViewBuilder(context, indexes),
                Positioned(
                  top: 0,
                  width: MyDimon.width(context),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: showHideWidget(context,
                            onTap: () => vProv.changeAppBarHeight(),
                            icon: Icon(
                              (vProv.isAppBarVisible)
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: MyColors.iconColor,
                            ),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15)),
                            leading: (vProv.isAppBarVisible)
                                ? Container()
                                : Material(
                                    color: MyColors.backGround,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: MyColors.iconColor,
                                        size: 20,
                                      ),
                                      splashRadius: 15,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: List.generate(
                          indexes + 1,
                          (index) => Container(
                            height: 2,
                            width: pageBarWidth,
                            color: vProv.pageIndex + 1 > index
                                ? MyColors.backGround
                                : Colors.grey.withAlpha(70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: showHideWidget(
                    context,
                    onTap: () {
                      vProv.changeBottomSheetState();
                      showModalBottomSheet(
                        barrierColor: Colors.white.withOpacity(0),
                        context: this.context,
                        backgroundColor: MyColors.backGround,
                        builder: (context) => bottomSheet(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ).whenComplete(() => vProv.changeBottomSheetState());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector showHideWidget(BuildContext context,
      {Function onTap, BorderRadius borderRadius, Icon icon, Widget leading}) {
    return GestureDetector(
      onTap: onTap ?? null,
      child: Container(
        width: MyDimon.width(context),
        height: 30,
        decoration: BoxDecoration(
          borderRadius:
              borderRadius ?? BorderRadius.vertical(top: Radius.circular(15)),
          color: MyColors.backGround,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: MyDimon.width(context),
              alignment: Alignment.center,
              child: icon ??
                  Icon(
                    (vProv.isBottomSheetVisible)
                        ? Icons.remove
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
            ),
            leading ??
                Text(
                  (sora.getPageNumber(vProv.pageIndex)).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
          ],
        ),
      ),
    );
  } //Scaffold

  bottomSheet() {
    return Container(
      height: MyDimon.height(context) * .4,
      child: Container(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: showHideWidget(
                  context,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )),
            Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "حجم الخط",
                    style: MyStyle.generalTextStyle(),
                  ),
                  NewWidget()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageViewBuilder(BuildContext context, int indexes) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          vProv.changePageIndex(index);
        },
        children: List.generate(
          indexes + 1,
          (index) => quranPage(context, indexes, index),
        ),
      ),
    );
  }

  Widget quranPage(BuildContext context, int indexes, int pageIndex) {
    ScrollController scrollbarController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, bottom: 30, left: 5, right: 5),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CupertinoScrollbar(
          controller: scrollbarController,
          isAlwaysShown: true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: MyDimon.width(context),
            child: ListView(
              controller: scrollbarController,
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pageIndex == 0 && sora.soraNumber != 9
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            child: (sora.soraNumber == 1)
                                ? Text(
                                    "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" +
                                        Arabic.ayaNumber(1),
                                    style: MyStyle.bsmalaTextStyle(),
                                    textDirection: TextDirection.rtl)
                                : Text("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                    style: MyStyle.bsmalaTextStyle(),
                                    textDirection: TextDirection.rtl),
                          )
                        : Container(),
                    surahAyasBuilder(pageIndex),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText surahAyasBuilder(int pageIndex) {
    prov.lastSora.soraNumber == sora.soraNumber
        ? prov.coloredIndex = prov.lastSora.ayaNumber - 1
        : prov.coloredIndex = -1;
    List<Ayat> ayatList = sora.getAyaListWithPageIndex2(pageIndex);
    List<TextSpan> suraTextList = [];

    for (int i = 0; i < ayatList.length; i++) {
      String s = "";

      if (sora.soraNumber == 1 && i == 0 && pageIndex == 0) {
        continue;
      } else if (i == 0 && pageIndex == 0) {
        s = (ayatList[i].ayaText)
                .replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")
                .trim() +
            Arabic.ayaNumber(ayatList[i].ayaNumber);
      } else {
        s = ayatList[i].ayaText + Arabic.ayaNumber(ayatList[i].ayaNumber);
      }
      TapGestureRecognizer y = TapGestureRecognizer();
      y.onTap = () {};
      y.onTapDown = (TapDownDetails d) {
        isSt = true;
        stre = Stream.fromFuture(
                Future.delayed(Duration(milliseconds: 300), () => "ahmed"))
            .listen((event) async {
          if (isSt) {
            isSt = false;
            selectTextAction(ayatList[i], pageIndex);

            showModalBottomSheet(
              barrierColor: Colors.black.withOpacity(.1),
              context: this.context,
              backgroundColor: MyColors.backGround,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => Container(
                padding: EdgeInsets.symmetric(
                    vertical: MyDimon.height(context) * .05),
                height: MyDimon.height(context) * .2,
                child: Wrap(
                  spacing: MyDimon.width(context) * .2,
                  alignment: WrapAlignment.center,
                  children: [
                    customBotton(
                        onPressed: () {
                          Share.share(massageMaker(sora.soraData[i - 1]),
                              subject: "زينوا القرآن بأصواتكم");
                        },
                        icon: Icon(
                          Icons.share,
                          size: MyDimon.height(context) * .04,
                          color: MyColors.backGround,
                        ),
                        height: MyDimon.height(context) * .1,
                        width: MyDimon.height(context) * .1),
                    customBotton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => ReadingAndListen(sora)));
                        },
                        icon: Icon(
                          Icons.queue_music,
                          size: MyDimon.height(context) * .04,
                          color: MyColors.backGround,
                        ),
                        height: MyDimon.height(context) * .1,
                        width: MyDimon.height(context) * .1),
//                    customBotton(
//                      onPressed: (){},
//                      icon: Icon(Icons.bookmark_border,size: MyDimon.height(context)*.04,color: MyColors.backGround,),
//                        height:  MyDimon.height(context)*.1,
//                        width:  MyDimon.height(context)*.1
//                    ),
                  ],
                ),
              ),
            );

            if (await Vibration.hasVibrator()) {
              Vibration.vibrate(duration: 50);
            }
          }
          stre.cancel();
        });
      };

      y.onTapUp = (TapUpDetails up) {
        if (isSt) {
          isSt = false;
          stre.cancel();
          selectTextAction(ayatList[i], pageIndex);
        }
      };

      suraTextList.add(
        TextSpan(
          text: s,
          style: MyStyle.ayatTextStyle(fontSize: vProv.sliderValue).copyWith(
            backgroundColor: ayatList[i].ayaNumber == prov.coloredIndex
                ? MyColors.selectedTabColor.withAlpha(1)
                : Colors.transparent,
            color: ayatList[i].ayaNumber == prov.coloredIndex
                ? MyColors.selectedTabColor
                : Colors.black87,
          ),
          recognizer: y,
        ),
      );
    }

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: suraTextList,
      ),
    );
  }

  selectTextAction(Ayat ayaList, int pageIndex) {
    prov.changeColoredIndex(ayaList.ayaNumber);
    prov.lastSora.soraNumber = sora.soraNumber;
    prov.lastSora.ayaNumber = ayaList.ayaNumber;
    prov.lastSora.pageNumber = pageIndex + 1;
  }

  String massageMaker(Ayat aya) {
    return """
  زينوا القرآن بأصواتكم❤️✨
  {${aya.ayaText}}
  [${sora.soraTitle}:${aya.ayaNumber}]
قراءة العفاسي:
  ${aya.ayaAudio}
     """;
  }

  Future<bool> onBackPressed() async {
    vProv.resetPage();
    return true;
  }
}

Widget customBotton(
    {Function onPressed, Icon icon, double width = 50, double height = 50}) {
  return RawMaterialButton(
    constraints: BoxConstraints(minWidth: width, minHeight: height),
    onPressed: onPressed ?? null,
    fillColor: Colors.white,
    textStyle: TextStyle(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    child: icon ?? null,
  );
}

class NewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ViewProvider vProv = Provider.of<ViewProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            vProv.sliderValue.toStringAsFixed(0),
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              RawMaterialButton(
                constraints: BoxConstraints(minWidth: 50, minHeight: 50),
                onPressed: vProv.decreaseSliderValue,
                fillColor: Colors.white,
                textStyle: TextStyle(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.remove),
              ),
              Expanded(
                child: Slider(
                  activeColor: Colors.white,
                  value: vProv.sliderValue,
                  onChanged: (value) {
                    vProv.changeSliderValue(value);
                    print(value);
                  },
                  min: 14,
                  max: 70,
                ),
              ),
              RawMaterialButton(
                constraints: BoxConstraints(minWidth: 50, minHeight: 50),
                onPressed: vProv.increaseSliderValue,
                fillColor: Colors.white,
                textStyle: TextStyle(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.add),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ],
      ),
    );
  }
}
