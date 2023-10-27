import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();

  Future<bool> toggleListening({
    required Function(String) onResult,
    required Function(bool) isListening,
  }) async {
    if (_speechToText.isListening) {
      _speechToText.stop();
      return true;
    }
    final bool isAvailable = await _speechToText.initialize(onStatus: (status) {
      switch (status) {
        case 'isListening':
          isListening(true);
          break;
        case 'isNotListening':
          isListening(false);
          break;
        default:
          break;
      }
    });

    if (isAvailable) {
      String temp = "";
      await _speechToText.listen(
          onResult: (value) => temp = value.recognizedWords);
      //added this bit for adding text at the end of the string
      // if you want to add text as you speak return the value immediately on listen method
      _speechToText.statusListener = (status) {
        switch (status) {
          case 'done':
            onResult(temp);
            break;
        }
      };
    }

    return isAvailable;
  }
}
