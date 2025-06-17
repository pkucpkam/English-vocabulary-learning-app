import 'package:hive/hive.dart';

part 'vocab.g.dart';

@HiveType(typeId: 0)
class Vocabulary extends HiveObject {
  @HiveField(0)
  String word;

  @HiveField(1)
  List<String> meanings;

  Vocabulary({required this.word, required this.meanings});

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'],
      meanings: List<String>.from(json['meanings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'word': word, 'meanings': meanings};
  }
}
