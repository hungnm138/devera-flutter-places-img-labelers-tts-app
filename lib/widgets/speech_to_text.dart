import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({Key? key}) : super(key: key);

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  int sp = 24;
  bool start = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  final SpeechToText _speechToText = SpeechToText();

  bool listening = false;
  bool speechEnabled = false;
  String? s = "Press and Speak";
  String word = "";

  int z = 0;

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Timer? timer;

  move() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (sp > 100) {
        sp = sp - 100;
      }
      if (sp < 0) {
        sp = sp + 100;
      }
      setState(() {
        sp = sp + z;
      });
    });
  }

  void startListening() async {
    try {
      await _speechToText.listen(onResult: onSpeechResult).catchError((e) {
        debugPrint("Error: $e");
      });

      if (start == false) {
        setState(() {
          start = true;
        });
        move();
      }

      setState(() {
        if (_speechToText.isListening) {
          listening = true;

          s = "Listening ";
          setState(() {});
        } else {
          debugPrint("Listening Not working");
        }
      });
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    setState(() {});
  }

  void stopListening() async {
    try {
      await _speechToText.stop();
      setState(() {
        if (_speechToText.isNotListening) {
          listening = false;
          s = "Stop Listening";
          setState(() {});
        } else {
          debugPrint("Listening Not stooping");
        }
      });
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      word = result.recognizedWords.trim();
      if (word == "left") {
        z = -1;
      } else if (word == "right") {
        z = 1;
      } else if (word == "up") {
        z = -10;
      } else if (word == "down") {
        z = 10;
      } else {
        z = 0;
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Command"),
        centerTitle: true,
      ),
      body: Container(
        height: mediaQH,
        width: mediaQW,
        color: Colors.white70,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: mediaQW * 0.9,
              width: mediaQW * 0.9,
              child: GridView.builder(
                itemCount: 100,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == sp ? Colors.red : Colors.white,
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "{$word}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: mediaQW * 0.0325,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "z is $z  ,  move is $sp",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: mediaQW * 0.0325,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (listening == false) {
                  startListening();
                } else {
                  stopListening();
                }
              },
              child: Container(
                height: mediaQW * 0.2,
                width: mediaQW * 0.2,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: speechEnabled == true
                    ? listening == false
                        ? const Icon(
                            Icons.hearing_disabled,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.hearing,
                            color: Colors.white,
                          )
                    : const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
