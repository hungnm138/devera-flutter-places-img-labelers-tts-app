import 'dart:convert';

// import 'dart:ui' as ui;
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';

enum TypeOfInfo { image, photo }

class ImageDetectionProvider with ChangeNotifier {
  List<ImageLabel> _listOfInformation = [];
  Image? _image = Image.asset("assets/images/example.jpg");
  final ImagePicker _picker = ImagePicker();
  bool _showImage = false;

  bool get showImage => _showImage;

  Image? get image => _image;

  List<ImageLabel> get informationExtracted => _listOfInformation;

  set fillListOfInformation(List<ImageLabel> list) {
    _listOfInformation = list;
    notifyListeners();
  }

  void reset() {
    _showImage = false;
    _listOfInformation = [];
    notifyListeners();
  }

  void getImage(String path) {
    List<int> imageBytes = io.File(path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    _image = Image.memory(
      base64Decode(base64Image),
      height: 300,
    );
  }

  Future<void> extractInformation(String path) async {
    final inputImage = InputImage.fromFilePath(path);

    final modelPath = await getModel('assets/ml/object_labeler2.tflite');
    final options = LocalLabelerOptions(modelPath: modelPath);
    final imageLabeler = ImageLabeler(options: options);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    await imageLabeler.close();

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      debugPrint("$text === $index === $confidence");
      _listOfInformation.add(ImageLabel(
          label: label.label,
          confidence: label.confidence,
          index: label.index));
    }

    getImage(path);
    _showImage = true;
    notifyListeners();
  }

  Future<void> processImage(TypeOfInfo type) async {
    if (type == TypeOfInfo.image) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      await extractInformation(image!.path);
    } else if (type == TypeOfInfo.photo) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      await extractInformation(photo!.path);
    }
  }

  Future<String> getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(pth.dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
