import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:provider/provider.dart';

import '../provider/image_detector_provider.dart';

class Watcher extends StatefulWidget {
  const Watcher({Key? key}) : super(key: key);

  @override
  State<Watcher> createState() => _WatcherState();
}

class _WatcherState extends State<Watcher> {
  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  void getImage() {
    final imageDetectionActions =
        Provider.of<ImageDetectionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await imageDetectionActions
                        .processImage(TypeOfInfo.image)
                        .whenComplete(() {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                      });
                    });
                  },
                  icon: const Icon(Icons.photo, color: Colors.redAccent),
                  label: const Text(
                    'Choose image...',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await imageDetectionActions
                        .processImage(TypeOfInfo.photo)
                        .whenComplete(() {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                      });
                    });
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.redAccent),
                  label: const Text(
                    'Take a picture',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showImage = Provider.of<ImageDetectionProvider>(context).showImage;
    Image image =
        Provider.of<ImageDetectionProvider>(context).image ?? Image.asset('');
    List<ImageLabel> informationExtracted =
        Provider.of<ImageDetectionProvider>(context).informationExtracted;
    final imageDetectionActions = Provider.of<ImageDetectionProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedCrossFade(
              firstChild: Center(
                child: TextButton(
                  onPressed: () {
                    getImage();
                  },
                  child: const Text(
                    'I wanna see...',
                    style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  ),
                ),
              ),
              secondChild: informationExtracted.isNotEmpty
                  ? AnimatedOpacity(
                      duration: const Duration(seconds: 3),
                      opacity: showImage ? 1.0 : 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          image,
                          const SizedBox(height: 20),
                          AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(milliseconds: 500),
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'This is what I see',
                                textStyle: const TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                                colors: colorizeColors,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              children: informationExtracted.map((information) {
                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Label: ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(information.label,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18))
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      Row(
                                        children: [
                                          const Text("Confidence: ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              information.confidence
                                                  .toInt()
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  imageDetectionActions.reset();
                                },
                                child: const Text('Let me see again...',
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 18)),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
              crossFadeState: !showImage
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(seconds: 1),
            ),
          ],
        ),
      ),
    );
  }
}
