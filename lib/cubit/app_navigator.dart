import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit_states.dart';
import '../pages/detail_page.dart';
import '../pages/onboarding_page.dart';
import '../widgets/loading_widget.dart';

import '../pages/main_page.dart';
import 'app_cubits.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          if (state is WelcomeState) {
            // return const WelcomePage();
            return const OnBoardingPage();
          } else if (state is LoadingState) {
            // return const Center(child: CircularProgressIndicator());
            return const Center(child: LoadingWidget());
          } else if (state is LoadedState) {
            // return HomePage();
            return const MainPage();
          } else if (state is DetailState) {
            return const DetailPage();
          } else {
            return Container(); // 404 Not found
          }
        },
      ),
    );
  }
}
