import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  FlutterTts tts = FlutterTts();

  Future<void> speak(String text) async {
    await tts.speak(text);
  }
} 