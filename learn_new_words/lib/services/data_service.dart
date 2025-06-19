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
    }
  }

  /// Truy xuất danh sách từ
  static Future<List<Vocabulary>> getAllVocabularies() async {
    final box = await Hive.openBox<Vocabulary>(boxName);
    return box.values.toList();
  }

  /// Cập nhật trạng thái học của một từ
  static Future<void> updateVocabularyLearnedStatus(
    Vocabulary vocab,
    bool isLearned, {
    DateTime? learnedDate,
  }) async {
    vocab.isLearned = isLearned;
    vocab.learnedDate = isLearned ? (learnedDate ?? DateTime.now()) : null;
    await vocab.save(); // Lưu thay đổi vào Hive
  }

  /// Lấy danh sách từ đã học
  static Future<List<Vocabulary>> getLearnedVocabularies() async {
    final box = await Hive.openBox<Vocabulary>(boxName);
    return box.values.where((vocab) => vocab.isLearned).toList();
  }

  /// Lấy danh sách từ chưa học
  static Future<List<Vocabulary>> getUnlearnedVocabularies() async {
    final box = await Hive.openBox<Vocabulary>(boxName);
    return box.values.where((vocab) => !vocab.isLearned).toList();
  }
}
