import 'package:flutter/material.dart';
import '../../widgets/speech_to_text.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // child: Text("Search Page"),
      child: SpeechToTextPage(),
    );
  }
}
