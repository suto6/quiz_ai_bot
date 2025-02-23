import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;

  Future<String> listen() async {
    if (!_isListening) {
      bool available = await speech.initialize();
      if (available) {
        _isListening = true;
        String recognizedWords = '';
        speech.listen(onResult: (result) {
          recognizedWords = result.recognizedWords;
        });

        // Stop listening after 10 seconds (adjust as needed)
        await Future.delayed(Duration(seconds: 10));
        speech.stop();
        _isListening = false;
        return recognizedWords;
      } else {
        return "Speech recognition not available";
      }
    } else {
      speech.stop();
      _isListening = false;
      return "";
    }
  }

  bool isListening() {
    return _isListening;
  }
} 