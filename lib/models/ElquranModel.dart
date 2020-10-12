class SurahsModel {
  final int soraIndex;
  final String soraTitle;
  final String soraPlace;
  final int soraAyatNumber;
  final int soraNumber;
  final List<Ayat> soraData;
  List<int> lastAyaNumber = [0];

  SurahsModel(
      {this.soraIndex,
      this.soraTitle,
      this.soraNumber,
      this.soraAyatNumber,
      this.soraPlace,
      this.soraData});

  factory SurahsModel.fromJson(dynamic json) {
    return SurahsModel(
      soraIndex: json["number"] - 1,
      soraTitle: (json["name"] as String)
          .replaceFirst("سورة", "")
          .replaceFirst("سُورَةُ", "")
          .trim(),
      soraNumber: json["number"],
      soraAyatNumber: (json["ayahs"] as List).length,
      soraPlace: json["revelationType"] == "Meccan" ? "مكية" : "مدنية",
      soraData: (json["ayahs"] as List<dynamic>)
          .map((value) => Ayat.fromSurah(value))
          .toList(),
    );
  }

  getFirstPageNumber() {
    return soraData[0].ayaPageNumber;
  }

  getLastPageNumber() {
    return soraData.last.ayaPageNumber;
  }

  getPagesIndexes() {
    return getLastPageNumber() - getFirstPageNumber();
  }

  getPageNumber(pageIndex) {
    return getFirstPageNumber() + pageIndex;
  }

  List<Ayat> getAyaListWithPageIndex(int pageIndex) {
    int pageNumber = getPageNumber(pageIndex);
    int lastIndex = 0;
    print(lastAyaNumber);
    List<Ayat> ayaListWithPage = [];
    for (int i = lastAyaNumber[pageIndex]; i < soraAyatNumber; i++) {
      if (soraData[i].ayaPageNumber != pageNumber) break;
      ayaListWithPage.add(soraData[i]);
      lastIndex = i;
    }
    lastAyaNumber
      ..remove(lastIndex)
      ..insert(pageIndex + 1, lastIndex);

    return ayaListWithPage;
  }

  getAyaListWithPageIndex2(int pageIndex) {
    int pageNumber = getFirstPageNumber() + pageIndex;
    List<Ayat> ayaListWithPage = [];
    for (int i = 0; i < soraAyatNumber; i++) {
      if (soraData[i].ayaPageNumber == pageNumber) {
        ayaListWithPage.add(soraData[i]);
      } else if (soraData[i].ayaPageNumber > pageNumber) {
        break;
      }
    }

    return ayaListWithPage;
  }
}

class Ayat {
  final String ayaText;
  final int ayaNumber;
  final String ayaAudio;
  final int ayaPageNumber;

  Ayat({this.ayaText, this.ayaNumber, this.ayaAudio, this.ayaPageNumber});

  factory Ayat.fromSurah(json) => Ayat(
      ayaNumber: json["numberInSurah"],
      ayaText: json['text'],
      ayaAudio: json['audio'],
      ayaPageNumber: json['page']);
}
