import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/widget/reading_list_tile.dart';

class SearchScreen extends StatelessWidget {
  ElsurahProvider prov;

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ElsurahProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (text) {
            prov.setSearchKey(text);
          },
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: prov.getSearchResultList().length,
          itemBuilder: (c, i) => SearchTile(prov.searchResultList[i]),
        ),
      ),
    );
  }
}

class SearchResult {
  SurahsModel sora;
  List<int> ayatNumber = [];

  SearchResult({this.sora, this.ayatNumber = const []});

  setAyatNumber(int value) {
    this.ayatNumber.add(value);
  }
}

class SearchTile extends StatelessWidget {
  BuildContext context;
  SearchResult searchResult;

  SearchTile(this.searchResult);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: lastListen(),
      ),
    );
  }

  Widget lastListen() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: MyColors.cardColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/card.jpg"),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xff911f8e).withAlpha(140),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    searchResult.sora.soraTitle,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    width: MyDimon.width(context) * .5,
                    height: 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    searchResult.sora.soraPlace +
                        " - " +
                        searchResult.sora.soraAyatNumber.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
        ReadingListTile2(
          ayah: searchResult.sora.soraData[1].ayaText,
          ayahNumber: 1,
        ),
        ReadingListTile2(
          ayah: searchResult.sora.soraData[2].ayaText,
          ayahNumber: 2,
        ),
        ReadingListTile2(
          ayah: searchResult.sora.soraData[3].ayaText,
          ayahNumber: 3,
        ),
      ],
    );
  }
}

class ReadingListTile2 extends StatelessWidget {
  final String ayah;
  final int ayahNumber;
  final Function onTap;

  const ReadingListTile2({this.ayah, this.ayahNumber, this.onTap});

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
                ayahNumber.toString(),
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
                  ayah,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "g3",
                  ),
                ),
                SizedBox(
                  height: 10,
                )
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
