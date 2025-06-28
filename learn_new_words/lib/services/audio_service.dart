import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/vocab.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  /// Kiểm tra xem file âm thanh có tồn tại trong assets không
  static Future<bool> checkAudioExists(String fileName) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      return manifestMap.keys.contains('assets/audio/$fileName');
    } catch (e) {
      return false;
    }
  }

  /// Phát file âm thanh cho từ vựng
  static Future<void> playAudio(Vocabulary vocab) async {
    try {
      String audioPath = vocab.audio ?? '${vocab.word}.mp3';
      if (await checkAudioExists(audioPath)) {
        await _player.play(AssetSource('audio/$audioPath'));
      } else {}
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}
