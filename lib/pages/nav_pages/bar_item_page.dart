import 'package:flutter/material.dart';
import '../../widgets/image_watcher.dart';

class BarItemPage extends StatelessWidget {
  const BarItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // child: Text("Bar Item Page"),
      child: Watcher(), // DEMO image labeling
    );
  }
}
