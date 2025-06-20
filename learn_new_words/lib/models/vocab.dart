import 'package:hive/hive.dart';

part 'vocab.g.dart';

@HiveType(typeId: 0)
class Vocabulary extends HiveObject {
  @HiveField(0)
  String word;

  @HiveField(1)
  List<Meaning> meanings;

  @HiveField(2)
  bool isLearned;

  @HiveField(3)
  DateTime? learnedDate;

  @HiveField(4)
  String? pronunciation_uk;

  Vocabulary({
    required this.word,
    required this.meanings,
    this.isLearned = false,
    this.learnedDate,
    this.pronunciation_uk,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'] as String,
      meanings:
          (json['meanings'] as List<dynamic>)
              .map((item) => Meaning.fromJson(item as Map<String, dynamic>))
              .toList(),
      isLearned:
          json['isLearned'] as bool? ?? false, // Mặc định false nếu không có
      learnedDate:
          json['learnedDate'] != null
              ? DateTime.tryParse(json['learnedDate'] as String)
              : null, // Mặc định null nếu không có
      pronunciation_uk: json['pronunciation_uk'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meanings': meanings.map((m) => m.toJson()).toList(),
      'isLearned': isLearned,
      'learnedDate': learnedDate?.toIso8601String(),
      'pronunciation_uk': pronunciation_uk,
    };
  }
}

@HiveType(typeId: 1)
class Meaning {
  @HiveField(0)
  String meaning;

  @HiveField(1)
  String example;

  Meaning({required this.meaning, required this.example});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      meaning: json['meaning'] as String,
      example: json['example'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'meaning': meaning, 'example': example};
  }
}
