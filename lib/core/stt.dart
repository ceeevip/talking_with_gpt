
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognizer {

  static final SpeechRecognizer _singleton = SpeechRecognizer._internal();

  factory SpeechRecognizer() {
    return _singleton;
  }

  SpeechRecognizer._internal(){
    _speech = SpeechToText();
    _speech.initialize().then((value) {
      print("SpeechRecognizer Initial Status: $value");
    }).catchError((onError){
      print("SpeechRecognizer Initial Failure $onError");
    });
  }

  late SpeechToText _speech;

  bool  _isListening = false;

  bool isListening() => _isListening;

  // 开始语音识别
  void startListening(Function(String) onResult) {
    _singleton._isListening = true;
    _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  // 停止语音识别
  void stopListening() {
    _singleton._isListening =false;
    _speech.stop();
  }
}