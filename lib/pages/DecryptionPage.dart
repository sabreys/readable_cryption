
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class DecryptionPage extends StatelessWidget {
  DecryptionPage({Key? key}) : super(key: key);
  InputImage? inputImage;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> test2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    inputImage = InputImage.fromFilePath(image!.path);
  }

  Future<void> test() async {
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage!);

    String text = recognizedText.text;
    print(text);
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints.cast<Offset>();
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () async {
           await test2();
           await test();
        },
        child: Text("sa"),
      )),
    );
  }
}
