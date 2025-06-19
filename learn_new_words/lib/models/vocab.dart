import 'package:hive/hive.dart';

part 'vocab.g.dart';

@HiveType(typeId: 0)
class Vocabulary extends HiveObject {
  @HiveField(0)
  String word;

  @HiveField(1)
  List<String> meanings;

  @HiveField(2)
  bool isLearned = false;

  @HiveField(3)
  DateTime? learnedDate;

  Vocabulary({
    required this.word,
    required this.meanings,
    this.isLearned = false,
    this.learnedDate,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'],
      meanings: List<String>.from(json['meanings']),
      isLearned:
          json['isLearned'] as bool? ??
          false, // Mặc định false nếu không có trong JSON
      learnedDate:
          json['learnedDate'] != null
              ? DateTime.tryParse(json['learnedDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meanings': meanings,
      'isLearned': isLearned,
      'learnedDate': learnedDate?.toIso8601String(),
    };
  }
}
