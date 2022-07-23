import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:super_secure/data/util/secure_storage.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<LoadApiEvent>((event, emit) async {
      emit(HomeLoadingState());
      await Future.delayed(Duration(seconds: 4));
      emit(HomeLoadedState());
    });
  }
}
