import 'package:flutter/material.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/values/color.dart';

class ListeningListTile extends StatelessWidget {
  final Ayat aya;
  final Function tapShare;
  final Function tapAudio;
  final Function tapBookMark;
  final bool audioIconState;

  ListeningListTile(
      {this.aya,
      this.tapShare,
      this.tapAudio,
      this.tapBookMark,
      this.audioIconState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: dataRow(),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 2,
            )),
      ],
    );
  }

  Widget dataRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: (audioIconState)
                  ? Colors.grey.withAlpha(20)
                  : MyColors.backGround.withAlpha(30),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      size: 35,
                      color: MyColors.backGround,
                    ),
                    onPressed: (tapBookMark ?? () {}),
                    splashRadius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    //play audio
                    icon: Icon(
                        (audioIconState)
                            ? Icons.play_circle_outline
                            : Icons.stop,
                        size: 35,
                        color: MyColors.backGround),
                    onPressed: (tapAudio ?? () {}),
                    splashRadius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.share, size: 35, color: MyColors.backGround),
                    onPressed: (tapShare ?? () {}),
                    splashRadius: 25,
                  ),
                ],
              ),
              CircleAvatar(
                child: Text(
                  aya.ayaNumber.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                backgroundColor: MyColors.backGround,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            aya.ayaText,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "g3",
            ),
          ),
        )
      ],
    );
  }
}
