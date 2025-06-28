// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabularyAdapter extends TypeAdapter<Vocabulary> {
  @override
  final int typeId = 0;

  @override
  Vocabulary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vocabulary(
      word: fields[0] as String,
      meanings: (fields[1] as List).cast<Meaning>(),
      isLearned: fields[2] as bool,
      learnedDate: fields[3] as DateTime?,
      pronunciation_uk: fields[4] as String?,
      audio: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Vocabulary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meanings)
      ..writeByte(2)
      ..write(obj.isLearned)
      ..writeByte(3)
      ..write(obj.learnedDate)
      ..writeByte(4)
      ..write(obj.pronunciation_uk)
      ..writeByte(5)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeaningAdapter extends TypeAdapter<Meaning> {
  @override
  final int typeId = 1;

  @override
  Meaning read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meaning(
      meaning: fields[0] as String,
      example: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Meaning obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.meaning)
      ..writeByte(1)
      ..write(obj.example);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeaningAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
