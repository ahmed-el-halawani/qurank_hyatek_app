import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:quran/models/ElquranModel.dart';

String elquran = "http://api.alquran.cloud/v1/quran/ar.alafasy";

enum Res { elquran, elsurah }

class JsonFileTest {
  JsonFileTest._();

  static JsonFileTest instance = JsonFileTest._();

  final String _elquranPath = "elquran.txt";
  final String _elsurahPath = "elsurah.txt";

  Future<bool> isElsurahPathPathExist() async {
    return File(await _getDir() + "/" + _elsurahPath).exists();
  }

  Future<bool> isElquranPathExist() async {
    return File(await _getDir() + "/" + _elquranPath).exists();
  }

  Future<bool> downloadResources() async {
    return await _writeData(http.get(elquran), _elquranPath);
  }

  Future<String> _getDir() async {
    Directory dir = await getExternalStorageDirectory();
    return dir.path;
  }

  Future<bool> _writeData(Future<http.Response> api, String path) async {
    var state = await api;
    if (state.statusCode == 200) {
      var dir = await _getDir() + "/" + path;
      if (!(await File(dir).exists())) {
        var file = File(dir);
        file.writeAsStringSync(state.body);
      } else {
        print("file exist at :" + dir);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getElquranDB() async {
    var dir = await _getDir() + "/" + _elquranPath;
    if (await File(dir).exists()) {
      var file = File(dir);
      return file.readAsString();
    }
    if (await downloadResources()) {
      return getElquranDB();
    }
    return null;
  }
}
