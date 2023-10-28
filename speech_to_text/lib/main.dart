import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stt/util/services/speech_to_text.dart';
import 'package:stt/util/services/text_to_speech.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  bool isListening = false;

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.

  /// This is the callback that the SpeechToText plugin calls when
  ///
  late TextToSpeechService _tts;
  @override
  void initState() {
    _tts = TextToSpeechService(FlutterTts());
    _tts.init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _textToRead = "I am muhit. I am a developer. How are you?";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last spoken words',
                  )),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: _textToRead != null && _start != 0
                        ? _textToRead!.substring(0, _start)
                        : "",
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: _textToRead != null
                        ? _textToRead!.substring(_start, _end)
                        : "",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        _textToRead != null ? _textToRead!.substring(_end) : "",
                    style: TextStyle(color: Colors.black)),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech _start, otherwise stop
            _toggleSpeaking,
        tooltip: 'Listen',
        child: Icon(!isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  Future<void> _toggleListening() async {
    await SpeechToTextService().toggleListening(
        onResult: (text) => setState(() {
              _controller.text += text;
              //remove the summation sign if not want to add text at the end as you speak
            }),
        isListening: (isListening) => setState(() {
              this.isListening = isListening;
            }));
  }

  int _start = 0;
  int _end = 0;
  Future<void> _toggleSpeaking() async {
    await _tts.speak(_textToRead, (int start, int end) {
      setState(() {
        _start = start;
        _end = end;
      });
    }, () {
      setState(() {
        _start = 0;
        _end = 0;
      });
    });
  }
}
