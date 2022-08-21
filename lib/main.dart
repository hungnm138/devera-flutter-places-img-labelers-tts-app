import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../cubit/app_navigator.dart';
import '../cubit/app_cubits.dart';
import '../services/api_services.dart';

import 'provider/image_detector_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageDetectionProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Places App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<AppCubits>(
          create: (context) => AppCubits(
            data: ApiServices(),
          ),
          child: const AppNavigator(),
        ),
      ),
    );
  }
}
