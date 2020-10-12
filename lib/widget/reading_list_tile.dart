import 'package:flutter/material.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/values/color.dart';

class ReadingListTile extends StatelessWidget {
  final SurahsModel sora;
  final Function onTap;

  const ReadingListTile({this.sora, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap ?? null,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: dataRow(),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 2,
                )),
          ],
        ),
      ),
    );
  }

  Row dataRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/8point_star.png"),
              )),
              child: Center(
                  child: Text(
                sora.soraNumber.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "ElMessiri",
                ),
              )),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sora.soraTitle,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "g3",
                  ),
                ),
                Text(
                    sora.soraPlace +
                        "- " +
                        sora.soraAyatNumber.toString() +
                        " أيات",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MyColors.unSelectedTextTabColor,
                    )),
              ],
            ),
          ),
        ),
        Icon(
          Icons.navigate_next,
          size: 40,
          color: MyColors.selectedTabColor,
        ),
      ],
    );
  }
}
