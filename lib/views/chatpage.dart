import 'package:flutter/material.dart';

import '../core/stt.dart';

class ChatBubble extends StatelessWidget {
  final String text;

  ChatBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[300],
      ),
      child: Text(text),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

enum TalkStatus {
  writeModel,
  speakModel;
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();

  List<String> _messages = [];

  TalkStatus _currentTalkStatus = TalkStatus.speakModel;

  SpeechRecognizer speechRecognizer = SpeechRecognizer();

  void _sendMessage() {
    setState(() {
      _messages.insert(0, _textEditingController.text);
    });
    _textEditingController.clear();
  }

  void switchTalkModel(TalkStatus talkStatus) {
    setState(() {
      _currentTalkStatus = talkStatus;
    });
  }

  String speakText = "";

  /// Text Input
  Row buildSpeakBottomRow() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard),
          onPressed: () => switchTalkModel(TalkStatus.speakModel),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Center(
                child: !speechRecognizer.isListening()
                    ? Text("Hold On To Speak")
                    : Text(("Loosen To Stop")),
              ),
              onTap: () {
                if (!speechRecognizer.isListening()) {
                  speechRecognizer.startListening((p0) {
                    speakText = p0;
                    print("===> $p0");
                  });
                  print("录音中...");
                } else {
                  speechRecognizer.stopListening();
                  print("结束...");
                }
                setState(() {});
              },
              // onTapDown: (xx) {
              //   print("按下...");
              //   speechRecognizer.startListening((p0) {
              //     speakText = p0;
              //     print("===> $p0");
              //   });
              // },
              // onTapUp: (details) {
              //   print("弹起....");
              //   speechRecognizer.stopListening();
              // },
            ),
          ),
        ),
      ],
    );
  }

  /// Speak to Input
  Row buildTextInputBottomRow() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.multitrack_audio),
          onPressed: () => switchTalkModel(TalkStatus.writeModel),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(text: _messages[index]);
              },
            ),
          ),
          _currentTalkStatus == TalkStatus.writeModel
              ? buildTextInputBottomRow()
              : buildSpeakBottomRow()
        ],
      ),
    );
  }
}
