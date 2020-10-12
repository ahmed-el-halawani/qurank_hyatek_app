import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/style.dart';

class MTabBar extends StatelessWidget {
  const MTabBar({Key key, @required this.tab, @required this.tabList})
      : super(key: key);

  final TabController tab;
  final List<Tab> tabList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyDimon.height(context) * .06,
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: MyColors.unSelectedTabColor,
              height: 5,
            ),
          ),
          TabBar(
            indicatorWeight: MyDimon.height(context) * .02,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: tab,
            unselectedLabelColor: MyColors.unSelectedTextTabColor,
            labelColor: MyColors.selectedTabColor,
            labelStyle: MyStyle.tabTextStyle(),
            indicator: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 5,
              color: MyColors.selectedTabColor,
            ))),
            tabs: tabList,
          ),
        ],
      ),
    );
  }
}
