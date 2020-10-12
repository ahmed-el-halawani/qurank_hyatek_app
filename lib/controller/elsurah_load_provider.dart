import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/models/SqlDB.dart';
import 'package:quran/pages/search_screen.dart';
import 'package:quran/repositry/jsonFileTest.dart';
import 'package:quran/models/saved_sora.dart';

class ElsurahProvider extends ChangeNotifier {
  JsonFileTest repo;

  ElsurahProvider._();

  StreamSubscription<AudioPlayerState> stream;
  static ElsurahProvider instance = ElsurahProvider._();

  bool allDone = false;

  List<SurahsModel> surahList = [];
  List<TextSpan> suraTextList = [];
  List<Ayat> suraTextList2 = [];
  bool downLoadRes = false;
  int coloredIndex = 0;
  int pageNumber = 1;

  int playedIndex = -1;
  int autoPlayIndex = 0;
  bool autoPlayState = false;
  final AudioPlayer audio = AudioPlayer();
  SavedSora lastSora = SavedSora();
  List<SavedSora> savedSoraList;

  int playedSoraNumber = -1;
  bool isAutoPlay = false;

  String searchKey = "الفاتحة";

  List<SearchResult> searchResultList = [];

  setLastSora() {}

  setSearchKey(String searchKey) {
    this.searchKey = searchKey;
    notifyListeners();
  }

  List<SearchResult> searcher() {
    searchResultList = [];
    for (SurahsModel s in surahList) {
      SearchResult result;
      if (replacer(s.soraTitle).contains(searchKey)) {
        result = SearchResult(sora: s);
      }
      for (Ayat a in s.soraData) {
        if (replacer(a.ayaText.trim()).contains(searchKey.trim())) {
          if (result == null) {
            result = SearchResult(sora: s, ayatNumber: [a.ayaNumber]);
          } else {
            List<int> tempList = [];
            tempList.addAll(result.ayatNumber);
            tempList.add(a.ayaNumber);
            result.ayatNumber = tempList;
          }
        }
      }
      if (result != null) {
        searchResultList.add(result);
      }
    }
  }

  String replacer(text) {
    String mytext = text;
    var remove = [
      r"\u0600-\u06FF",
      'ِ',
      'ُ',
      'ٓ',
      'ٰ',
      'ْ',
      'ٌ',
      'ٍ',
      'ً',
      'ّ',
      'َ'
    ];
    Map<String, String> rem2 = {"ٱ": "ا", "آل": "ال"};
    rem2.forEach((key, value) {
      mytext = mytext.replaceAll(key, value);
    });
    remove.forEach((element) {
      mytext = mytext.replaceAll(element, "");
    });
    return mytext;
  }

  List<SearchResult> getSearchResultList() {
    if (searchKey.isNotEmpty) {
      searcher();
    }
    return searchResultList;
  }

  setAllDoneState(bool isAllDone) {
    allDone = isAllDone;
    notifyListeners();
  }

  Future<void> playAudio(SurahsModel sora, index) async {
    playedIndex = index + 1;
    autoPlayIndex = index;
    if (stream != null) stream.cancel();

    notifyListeners();
    int x =
        await audio.play(sora.soraData[autoPlayIndex].ayaAudio, isLocal: false);
    if (x == 1) {
      print("suc");
    }

    stream = audio.onPlayerStateChanged.listen((event) {
      print(event);
      if (event == AudioPlayerState.COMPLETED) {
        playedIndex = -1;
        notifyListeners();
        if (autoPlayState && autoPlayIndex + 1 < sora.soraAyatNumber) {
          print(autoPlayIndex);
          playAudio(sora, ++autoPlayIndex);
        } else {
          autoPlayIndex = 0;
        }
      }
    });
  }

  Future<void> autoPlayAudio(SurahsModel sora, index) async {
    print("sora ayat number: " + sora.soraAyatNumber.toString());
    isAutoPlay = true;
    playedIndex = index + 1;
    playedSoraNumber = sora.soraNumber;
    autoPlayIndex = index;
    if (stream != null) stream.cancel();

    notifyListeners();
    int x =
        await audio.play(sora.soraData[autoPlayIndex].ayaAudio, isLocal: false);
    if (x == 1) {
      print("suc");
    }

    stream = audio.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.COMPLETED) {
        playedIndex = -1;
        notifyListeners();
        if (autoPlayIndex + 1 < sora.soraAyatNumber) {
          autoPlayAudio(sora, ++autoPlayIndex);
        } else {
          autoPlayIndex = 0;
        }
      }
    });
  }

  Future<void> onStop() {
    audio.stop();
    autoPlayState = false;
    playedIndex = -1;
    playedSoraNumber = -1;
    isAutoPlay = false;
    notifyListeners();
  }

  onCanselSup() {
    stream.cancel();
    autoPlayIndex = 0;
    playedIndex = -1;
  }

  Future<void> DownLoadRes() async {
    repo = JsonFileTest.instance;

    bool isDone = await repo.isElquranPathExist();
    if (!isDone) {
      await repo.downloadResources();
      downLoadRes = true;
    } else {
      downLoadRes = true;
    }
    notifyListeners();
  }

  bool isDownloadDone() {
    if (!downLoadRes) DownLoadRes();
    return downLoadRes;
  }

  Future loadMoreSurah() async {
    var json = await repo.getElquranDB();
    List<SurahsModel> value = await compute(surahsListBuilder, json);
    surahList = value;
    notifyListeners();
  }

  List<SurahsModel> getList() {
    if (surahList.isEmpty) {
      loadMoreSurah();
    }
    ;
    return surahList;
  }

  List<SavedSora> getSavedSoraReady() {
    SqlDB db = SqlDB.instance;
    if (savedSoraList == null) {
      db.getSavedSoraList().then((value) {
        savedSoraList = savedSurahListBuilder(value);
        lastSora =
            (savedSoraList.isNotEmpty) ? savedSoraList.last : SavedSora();
        notifyListeners();
      });
    }
    return savedSoraList;
  }

  setSavedSora(SavedSora sora) {
    SqlDB db = SqlDB.instance;
    db.setSavedSora(sora).then((value) {
      lastSora = sora;
      notifyListeners();
      savedSoraList = null;
      getSavedSoraReady();
    });
  }

  prepareSoraWithData(SurahsModel sora) {
    for (SavedSora i in savedSoraList) {
      if (i.soraNumber == sora.soraNumber) {
        coloredIndex = i.ayaNumber;
        pageNumber = i.pageNumber;
        return;
      }
    }
    pageNumber = 0;
    coloredIndex = 0;
  }

  SavedSora getSavedSora(SurahsModel sora) {
    for (SavedSora i in savedSoraList) {
      if (i.soraNumber == sora.soraNumber) {
        return i;
      }
    }
    return SavedSora();
  }

  void changeColoredIndex(index) {
    coloredIndex = index;
    notifyListeners();
  }

  removeElSuraTextList() {
    coloredIndex = -1;
    suraTextList.clear();
  }
}

List<SurahsModel> surahsListBuilder(jsonList) {
  List<SurahsModel> surahList = [];
  List<dynamic> x = jsonDecode(jsonList)["data"]["surahs"];
  return x.map((e) => SurahsModel.fromJson(e)).toList();
}

List<SavedSora> savedSurahListBuilder(
    List<Map<String, dynamic>> savedSurahSql) {
  List<SurahsModel> surahList = [];
  return savedSurahSql.map((e) => SavedSora.fromSql(e)).toList();
}
