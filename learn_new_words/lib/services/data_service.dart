import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/vocab.dart';

class DataService {
  static const String boxName = 'vocabularyBox';

  /// Hàm chạy lần đầu để load từ file JSON và lưu vào Hive
  static Future<void> initVocabularyFromJsonIfNeeded() async {
    final box = await Hive.openBox<Vocabulary>(boxName);

    if (box.isEmpty) {
      final jsonString = await rootBundle.loadString('data/vocabulary.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final List<Vocabulary> vocabList =
          jsonList.map((jsonItem) => Vocabulary.fromJson(jsonItem)).toList();

      await box.addAll(vocabList);
      print("Vocabulary loaded into Hive.");
    } else {
      print("Vocabulary already initialized.");
    }
  }

  /// Truy xuất danh sách từ
  static Future<List<Vocabulary>> getAllVocabularies() async {
    final box = await Hive.openBox<Vocabulary>(boxName);
    return box.values.toList();
  }
}
