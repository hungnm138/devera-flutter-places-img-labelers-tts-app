import 'package:bloc/bloc.dart';
import '../cubit/app_cubit_states.dart';
import '../models/place_model.dart';
import '../services/api_services.dart';

class AppCubits extends Cubit<CubitStates> {
  AppCubits({required this.data}) : super(InitialState()) {
    emit(WelcomeState());
  }

  final ApiServices data;
  late final List<PlaceModel> places;

  void getData() async {
    try {
      emit(LoadingState());
      // await Future.delayed(const Duration(seconds: 2), () => {});
      places = await data.getInfo();
      emit(LoadedState(places));
    } catch (e) {
      e.toString();
    }
  }

  detailPage(PlaceModel data) => emit(DetailState(data));

  goHome() => emit(LoadedState(places));
}
