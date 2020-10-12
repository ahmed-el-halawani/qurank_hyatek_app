import 'package:path_provider/path_provider.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/models/saved_sora.dart';
import 'package:sqflite/sqflite.dart';

class SqlDB {
  SqlDB._();

  static SqlDB instance = SqlDB._();

  Database db;

  Future<Database> getDatabase() async {
    if (db != null) return db;
    db = await createDatabase();
    return db;
  }

  Future<Database> createDatabase() async {
    return await openDatabase(
        (await getExternalStorageDirectory()).path + "/database.db",
        version: 1, onCreate: (db, _) {
      db.execute("""
          CREATE TABLE `savedsora` (
            `ayaNumber` int(11) NOT NULL DEFAULT -1,
            `soraNumber` int(11) NOT NULL DEFAULT 1,
            `pageIndex` int(11) NOT NULL DEFAULT 0,
            `name` varchar(23) NOT NULL DEFAULT 'لم تبدأ القرأة بعد',
            PRIMARY KEY (`name`)
          )
          """);
    });
  }

  Future<List<Map<String, dynamic>>> getSavedSoraList() async {
    return (await getDatabase()).rawQuery("select * from savedsora");
  }

  Future<int> setSavedSora(SavedSora sora) async {
    return (await getDatabase()).transaction((txn) {
      return txn.rawInsert("""
        INSERT OR REPLACE INTO `savedsora`
        (`name`,`ayaNumber`, `soraNumber`, `pageIndex`)
        VALUES 
        ("${sora.soraName}",${sora.ayaNumber},${sora.soraNumber},${sora.pageNumber}) 
        """);
    });
  }
}
