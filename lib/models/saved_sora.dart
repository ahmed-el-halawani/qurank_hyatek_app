class SavedSora {
  int pageNumber;
  int ayaNumber;
  int soraNumber;
  String soraName;

  SavedSora(
      {this.pageNumber = 0,
      this.ayaNumber = 1,
      this.soraNumber = 1,
      this.soraName});

  factory SavedSora.fromSql(Map<String, dynamic> mapName) => SavedSora(
      soraName: mapName["name"],
      ayaNumber: mapName["ayaNumber"],
      soraNumber: mapName["soraNumber"],
      pageNumber: mapName["pageIndex"]);
}
