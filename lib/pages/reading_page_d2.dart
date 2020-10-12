import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/controller/viewProvider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/models/saved_sora.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/extentions.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/values/style.dart';
import 'package:quran/widget/responsive_box.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class ReadingPageD2 extends StatelessWidget {
  final SurahsModel sora;
  ElsurahProvider prov;
  ViewProvider vProv;
  ScrollController cont;
  bool firstOpen = true;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;
  StreamSubscription stre;
  bool isSt = false;

  ReadingPageD2(this.sora);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    prov = Provider.of<ElsurahProvider>(context);
    vProv = Provider.of<ViewProvider>(context);
    if (firstOpen) {
      firstOpen = false;
      MyStyle.mainTheme2();
      prov.prepareSoraWithData(sora);
      vProv.prepareSoraWithData(prov.getSavedSora(sora));
      print(prov.coloredIndex);
    }
    pageController = PageController(initialPage: vProv.pageIndex);

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
          floatingActionButton: (prov.playedIndex != -1)
              ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton(
                      onPressed: prov.onStop,
                      backgroundColor: MyColors.backGround,
                      child: Icon(
                        Icons.stop,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : null,
          key: scaffoldKey,
          appBar: AppBar2(
            sora: sora,
            height: vProv.appBarHeight,
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
                                    color: MyColors.backgroundDark,
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
                        backgroundColor: MyColors.backgroundDark,
                        builder: (context) => bottomSheet(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
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

  Widget showHideWidget(BuildContext context,
      {Function onTap, BorderRadius borderRadius, Icon icon, Widget leading}) {
    return Container(
      width: MyDimon.width(context),
      height: 30,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? BorderRadius.vertical(top: Radius.circular(15)),
        color: MyColors.backgroundDark,
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          GestureDetector(
              onTap: onTap ?? null,
              child: Container(
                color: MyColors.backgroundDark,
                width: MyDimon.width(context),
                alignment: Alignment.center,
                child: icon ??
                    Icon(
                      (vProv.isBottomSheetVisible)
                          ? Icons.remove
                          : Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
              )),
          (leading == null) ? zoomInLine() : Container(),
          Positioned(
            left: (leading == null) ? 20 : null,
            right: (leading != null) ? 20 : null,
            child: leading ??
                Text(
                  (sora.getPageNumber(vProv.pageIndex)).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
          ),
        ],
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
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "حجم الخط",
                    style: MyStyle.generalTextStyle(),
                  ),
                  FontSizeResizerBottomSheet()
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
          if (stre != null) {
            stre.cancel();
          }
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
    scrollbarController.addListener(() {
      if (stre != null) {
        stre.cancel();
      }
    });
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoScrollbar(
        controller: scrollbarController,
        isAlwaysShown: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: 20,
              height: MyDimon.height(context),
              child: Container(
                decoration: BoxDecoration(
                    image: (MyDimon.height(context) > MyDimon.width(context))
                        ? DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/images/left_border.png"),
                          )
                        : null),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              width: 20,
              height: MyDimon.height(context),
              child: Container(
                decoration: BoxDecoration(
                    image: (MyDimon.height(context) > MyDimon.width(context))
                        ? DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/images/right_border.png"),
                          )
                        : null),
              ),
            ),
            Positioned(
              top: 30,
              height: 20,
              width: MyDimon.width(context),
              child: Container(
                decoration: BoxDecoration(
                    color: MyColors.quranPageBackground,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/top_border.png"),
                    )),
              ),
            ),
            Positioned(
              bottom: 30,
              height: 20,
              width: MyDimon.width(context),
              child: Container(
                decoration: BoxDecoration(
                    color: MyColors.quranPageBackground,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/bottom_border.png"),
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 60.0, bottom: 60, left: 40, right: 40),
              alignment: Alignment.center,
              child: ListView(
                controller: scrollbarController,
                shrinkWrap: true,
                children: [
                  Container(
                    child: Column(
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
                                    : Text(
                                        "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                        style: MyStyle.bsmalaTextStyle(),
                                        textDirection: TextDirection.rtl),
                              )
                            : Container(),
                        surahAyasBuilder(pageIndex),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText surahAyasBuilder(int pageIndex) {
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
        print("sora ayat number: " + this.sora.soraAyatNumber.toString());

        isSt = true;
        stre = Stream.fromFuture(
                Future.delayed(Duration(milliseconds: 700), () => "ahmed"))
            .listen((event) async {
          if (isSt) {
            isSt = false;
//            selectTextAction(ayatList[i], pageIndex);

            showModalBottomSheet(
              barrierColor: Colors.black.withOpacity(.1),
              context: this.context,
              backgroundColor: MyColors.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => OnLongClickBottomSheet(
                ayaIndex: ayatList[i].ayaNumber - 1,
                sora: this.sora,
                onMarkPressed: () {
                  selectTextAction(ayatList[i], pageIndex);
                },
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
                : (ayatList[i].ayaNumber == prov.playedIndex &&
                        prov.playedSoraNumber == sora.soraNumber)
                    ? Colors.blue
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
    prov.changeColoredIndex(
        (ayaList.ayaNumber == prov.coloredIndex) ? 0 : ayaList.ayaNumber);
    prov.lastSora.soraNumber = sora.soraNumber;
    prov.lastSora.soraName = sora.soraTitle;
    prov.lastSora.ayaNumber =
        prov.lastSora.ayaNumber == ayaList.ayaNumber ? 0 : ayaList.ayaNumber;
    prov.lastSora.pageNumber = pageIndex;
    prov.setSavedSora(prov.lastSora);
  }

  Future<bool> onBackPressed() async {
    vProv.resetPage();
    return true;
  }
}

class zoomInLine extends StatelessWidget {
  ViewProvider vProv;

  @override
  Widget build(BuildContext context) {
    vProv = Provider.of<ViewProvider>(context);
    return Positioned(
      right: 20,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              vProv.increaseSliderValue();
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            vProv.sliderValue.toStringAsFixed(0),
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                vProv.decreaseSliderValue();
              },
              icon: Icon(Icons.remove, color: Colors.white, size: 30)),
        ],
      ),
    );
  }
}

class CustomBotton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  final double width;
  final double height;

  const CustomBotton(
      {this.onPressed, this.icon, this.width = 50.0, this.height = 50.0});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      onPressed: onPressed ?? null,
      fillColor: Colors.white,
      textStyle: TextStyle(color: Colors.black),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyDimon.width(context) * .1)),
      child: icon ?? null,
    );
  }
}

class FontSizeResizerBottomSheet extends StatelessWidget {
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

class OnLongClickBottomSheet extends StatelessWidget {
  int ayaIndex;
  Function onPlayTap;
  SurahsModel sora;
  Function onMarkPressed;

  OnLongClickBottomSheet(
      {this.onPlayTap, this.ayaIndex, this.sora, this.onMarkPressed});

  ElsurahProvider prov;

  String massageMaker(Ayat aya) {
    return """
  زينوا أصواتكم بالقرآن ❤️✨
  {${aya.ayaText}}
  [${sora.soraTitle}:${aya.ayaNumber}]
قراءة العفاسي:
  ${aya.ayaAudio}
     """;
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ElsurahProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: MyDimon.width(context) * .05),
      height: MyDimon.width(context) * .4,
      child: Wrap(
        spacing: (MyDimon.width(context) * .2) / 5,
        alignment: WrapAlignment.center,
        children: [
          Column(
            children: [
              CustomBotton(
                onPressed: () {
                  Share.share(massageMaker(sora.soraData[ayaIndex]),
                      subject: "زينوا القرآن بأصواتكم");
                },
                icon: Icon(
                  Icons.share,
                  size: MyDimon.height(context) * .04,
                  color: MyColors.backgroundDark,
                ),
                height: MyDimon.width(context) * .2,
                width: MyDimon.width(context) * .2,
              ),
              SizedBox(
                height: 2,
              ),
              ResponsiveBox(
                height: MyDimon.width(context) * .1,
                width: MyDimon.width(context) * .2,
                child: Text(
                  "شارك الاية",
                  style: MyStyle.generalTextStyle(),
                ),
              )
            ],
          ),
          Column(
            children: [
              CustomBotton(
                onPressed: onMarkPressed ?? null,
                icon: Icon(
                  (prov.lastSora.ayaNumber - 1 == ayaIndex)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  size: MyDimon.height(context) * .04,
                  color: MyColors.backgroundDark,
                ),
                height: MyDimon.width(context) * .2,
                width: MyDimon.width(context) * .2,
              ),
              SizedBox(
                height: 2,
              ),
              ResponsiveBox(
                height: MyDimon.width(context) * .1,
                width: MyDimon.width(context) * .2,
                child: Text(
                  "تحديد الاية",
                  style: MyStyle.generalTextStyle(),
                ),
              )
            ],
          ),
          Column(
            children: [
              CustomBotton(
                onPressed: () {
                  if (prov.playedIndex != -1) {
                    prov.onStop();
                  } else {
                    prov.playAudio(sora, ayaIndex);
                  }
                },
                icon: Icon(
                  (prov.playedIndex != -1) ? Icons.stop : Icons.play_arrow,
                  size: MyDimon.height(context) * .04,
                  color: MyColors.backgroundDark,
                ),
                height: MyDimon.width(context) * .2,
                width: MyDimon.width(context) * .2,
              ),
              SizedBox(
                height: 2,
              ),
              ResponsiveBox(
                height: MyDimon.width(context) * .1,
                width: MyDimon.width(context) * .2,
                child: Text(
                  "تشغيل الأية",
                  style: MyStyle.generalTextStyle(),
                ),
              )
            ],
          ),
          Column(
            children: [
              CustomBotton(
                onPressed: () {
                  if (prov.playedIndex != -1) {
                    prov.onStop();
                  } else {
                    prov.autoPlayAudio(sora, ayaIndex);
                  }
                },
                icon: Icon(
                  Icons.playlist_play,
                  size: MyDimon.height(context) * .04,
                  color: (prov.isAutoPlay)
                      ? MyColors.backGround
                      : MyColors.backgroundDark,
                ),
                height: MyDimon.width(context) * .2,
                width: MyDimon.width(context) * .2,
              ),
              SizedBox(
                height: 2,
              ),
              ResponsiveBox(
                height: MyDimon.width(context) * .1,
                width: MyDimon.width(context) * .2,
                child: Text(
                  "تشغيل الكل",
                  style: MyStyle.generalTextStyle(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final SurahsModel sora;

  AppBar2({this.sora, double height});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<ViewProvider>(context);
    return AnimatedContainer(
      height: prov.appBarHeight,
      duration: Duration(milliseconds: 150),
      child: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: MyColors.backgroundDark,
            height: 1,
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
        centerTitle: true,
        backgroundColor: MyColors.backgroundDark,
        elevation: 0,
        title: Text(
          sora.soraTitle,
          style: TextStyle(
            fontFamily: Fonts.elquran,
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight - 1);
}
