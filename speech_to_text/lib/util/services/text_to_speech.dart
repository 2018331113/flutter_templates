import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TextToSpeechService {
  final FlutterTts _flutterTts;

  TextToSpeechService(this._flutterTts);

  String language = 'en-US';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  int start = 0;
  int end = 0;

  TtsState ttsState = TtsState.stopped;
  get flutterTts => _flutterTts;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  Future init() async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setVolume(volume);
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(pitch);
  }

  Future speak(String text, Function(int start, int end) onPrgress, Function() onDone) async {
    ttsState = TtsState.playing;

    await _flutterTts.speak(text);
    _flutterTts.setProgressHandler(
        (String text, int start, int end, String word) {
      onPrgress(start, end);
    });
    _flutterTts.completionHandler = () {
      ttsState = TtsState.stopped;
      onDone();
    };
  }

  Future stop() async {
    ttsState = TtsState.stopped;
    await _flutterTts.stop();
  }

  Future pause() async {
    ttsState = TtsState.paused;
    await _flutterTts.pause();
  }

  Future continueSpeak() async {
    ttsState = TtsState.continued;
  }
}
