import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/pages/reading_page2.dart';
import 'package:quran/pages/reading_page_d2.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/extentions.dart';
import 'package:quran/values/style.dart';
import 'package:quran/widget/shimmer.dart';

class LastRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ElsurahProvider prov = Provider.of<ElsurahProvider>(context);
    SurahsModel sora = prov.surahList[prov.lastSora.soraNumber - 1];

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MyDimon.height(context) * .03, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadingPageD2(sora),
              ));
        },
        child: Container(
          alignment: Alignment.centerRight,
          height: MediaQuery.of(context).size.height * .2,
          padding: EdgeInsets.only(right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyColors.cardColor,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/card.jpg"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "اخر قراءة",
                style: MyStyle.textSmall,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sora.soraTitle, style: MyStyle.textBig),
                  (prov.lastSora.ayaNumber != 0)
                      ? Text(
                          "اية رقم: " +
                              Arabic.numberToArabic(prov.lastSora.ayaNumber),
                          style: MyStyle.textSmall)
                      : Text("لم يتم تحديد أية", style: MyStyle.textSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
