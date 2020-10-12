import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/constProvider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/controller/viewProvider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/models/const_models.dart';
import 'package:quran/pages/reading_and_listen.dart';
import 'package:quran/pages/reading_page2.dart';
import 'package:quran/pages/reading_page_d2.dart';
import 'package:quran/pages/search_screen.dart';
import 'package:quran/values/color.dart';
import 'package:quran/values/dimon.dart';
import 'package:quran/values/fonts.dart';
import 'package:quran/widget/last_read.dart';
import 'package:quran/widget/loading.dart';
import 'package:quran/widget/reading_list_tile.dart';
import 'package:quran/widget/m_tab_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tab;
  List<Tab> tabList;
  ShowState state = ShowState.readingOnly;
  ElsurahProvider surahProv;
  ConstProvider cProv;
  ViewProvider vProv;
  int segmentGroupValue = 0;
  bool isFirst = true;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    tab = TabController(vsync: this, length: 2, initialIndex: 0);
    tab.addListener(() {
      state = tab.previousIndex == 1
          ? ShowState.readingOnly
          : ShowState.listenAndMore;
    });

    scrollController.addListener(() {
      if (scrollController.offset > MyDimon.height(context) * .26 &&
          vProv.shrincSelectionStateBox == false) {
        vProv.changeSelectionState(true);
      } else if (scrollController.offset < MyDimon.height(context) * .26 &&
          vProv.shrincSelectionStateBox == true) {
        vProv.changeSelectionState(false);
      }
    });

    tabList = [
      Tab(
        text: "قراءة",
      ),
      Tab(
        text: "الاستماع",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    surahProv = Provider.of<ElsurahProvider>(context);
    vProv = Provider.of<ViewProvider>(context);
    cProv = Provider.of<ConstProvider>(context);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: surahProv.surahList.length + 2,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return LastRead();
                        } else if (i == 1) {
                          return MTabBar(tab: tab, tabList: tabList);
                        } else {
                          return buildSurahList(surahProv.surahList[i - 2]);
                        }
                      }),
                ),
                shrenk(MTabBar(
                  tab: tab,
                  tabList: tabList,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSurahList(SurahsModel sora) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ReadingListTile(
        sora: sora,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (state == ShowState.readingOnly)
                  ? cProv.themeState == themeSelectKey.modernTheme
                      ? ReadingScreen2(sora)
                      : ReadingPageD2(sora)
                  : ReadingAndListen(sora),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tab.removeListener(() {
      print('removed');
    });
    print('removed');
  }

  @override
  void deactivate() {
    super.deactivate();
    tab.removeListener(() {
      print('removed');
    });
    print('removed');
  }

  int i = 0;

  Future<bool> onBackPressed() async {
    if (i < 1) {
      i++;
      print("not 2");
      Future.delayed(Duration(seconds: 5), () {
        i = 0;
        print(i = 0);
      });
      Fluttertoast.showToast(
          msg: "اضغط رجوع مرة اخري للخروج", toastLength: Toast.LENGTH_LONG);
      return false;
    }
    return true;
  }
}

class shrenk extends StatelessWidget {
  MTabBar tabBar;
  ScrollController cont;

  shrenk(this.tabBar);

  @override
  Widget build(BuildContext context) {
    var vProv = Provider.of<ViewProvider>(context);
    return Positioned(
        height: kToolbarHeight +
            (vProv.shrincSelectionStateBox ? MyDimon.height(context) * .06 : 0),
        width: MyDimon.width(context),
        top: 0,
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(vProv.shrincSelectionStateBox
                ? MyDimon.height(context) * .06
                : 0),
            child: vProv.shrincSelectionStateBox ? tabBar : Container(),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "قرانك حياتك",
            style: TextStyle(
                fontFamily: Fonts.elquran,
                fontSize: 45,
                color: MyColors.selectedTabColor),
          ),
        ));
  }
}
