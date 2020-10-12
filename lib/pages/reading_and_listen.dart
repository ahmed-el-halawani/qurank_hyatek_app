import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/widget/listen_list_tile.dart';
import 'package:quran/widget/responsive_box.dart';
import 'package:share/share.dart';

class ReadingAndListen extends StatelessWidget {
  final SurahsModel sora;
  ElsurahProvider prov;
  BuildContext context;

  ReadingAndListen(this.sora);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    this.context = context;
    prov = Provider.of<ElsurahProvider>(context);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (prov.playedIndex != -1) {
                prov.onStop();
              } else {
                prov.autoPlayState = true;
                prov.playAudio(sora, prov.autoPlayIndex);
              }
            },
            child: prov.playedIndex != -1
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
          ),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              sora.soraTitle,
              style: TextStyle(
                  fontFamily: Fonts.elquran,
                  fontSize: 50,
                  color: MyColors.selectedTabColor),
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: ListView.builder(
                controller: controller,
                itemCount: sora.soraData.length + 1,
                itemBuilder: (c, i) {
                  if (i == 0) {
                    return lastListen();
                  } else if (i < sora.soraData.length) {
                    return ListeningListTile(
                      audioIconState: prov.playedIndex == i ? false : true,
                      aya: sora.soraData[i - 1],
                      tapAudio: () {
                        if (prov.playedIndex != -1) {
                          prov.onStop();
                        } else {
                          prov.playAudio(sora, i - 1);
                        }
                      },
                      tapShare: () {
                        print(massageMaker(sora.soraData[i - 1]));
                        Share.share(massageMaker(sora.soraData[i - 1]),
                            subject: "زينوا القرآن بأصواتكم");
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: ListeningListTile(
                        audioIconState: prov.playedIndex == i ? false : true,
                        aya: sora.soraData[i - 1],
                        tapAudio: () {
                          if (prov.playedIndex != -1) {
                            prov.onStop();
                          } else {
                            prov.playAudio(sora, i - 1);
                          }
                        },
                        tapShare: () {
                          print(massageMaker(sora.soraData[i - 1]));
                          Share.share(massageMaker(sora.soraData[i - 1]),
                              subject: "زينوا القرآن بأصواتكم");
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
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

  lastListen() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * .25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: MyColors.cardColor,
            boxShadow: [
              BoxShadow(
                  color: Color(0xff911f8e),
                  blurRadius: 18,
                  spreadRadius: -12,
                  offset: Offset.fromDirection(1.5, 13))
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/card.jpg"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * .25,
          margin: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xff911f8e).withAlpha(140),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveBox(
                width: MyDimon.width(context) * .5,
                height: MyDimon.height(context) * .07,
                child: Text(
                  sora.soraTitle,
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
              SizedBox(
                width: MyDimon.width(context) * .5,
                height: 1,
                child: Container(
                  color: Colors.white,
                ),
              ),
              ResponsiveBox(
                width: MyDimon.width(context) * .5,
                height: MyDimon.height(context) * .07,
                child: Text(
                  sora.soraPlace + " - " + sora.soraAyatNumber.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              ResponsiveBox(
                width: MyDimon.width(context) * .6,
                height: MyDimon.height(context) * .08,
                child: Text(
                  "8", //el basmala
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 200,
                      fontFamily: Fonts.Besmellah,
                      height: .1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: MyDimon.height(context) * .02,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int i = 0;

  Future<bool> onBackPressed() async {
    return true;
  }
}
