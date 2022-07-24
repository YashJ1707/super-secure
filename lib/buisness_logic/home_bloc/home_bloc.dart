import 'package:bloc/bloc.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:meta/meta.dart';
import 'package:super_secure/data/models/data_model.dart';
import 'package:super_secure/data/repository_provider/web_pages_repository.dart';
import 'package:super_secure/data/util/secure_storage.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    //Event to get the data
    on<LoadApiEvent>((event, emit) async {
      emit(HomeLoadingState());
      // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      List<University> universities =
          await WebPagesRepository().getWebPageModelFromRawData();
      // ScreenshotCallback screenShotCallBack = ScreenshotCallback();
      // screenShotCallBack.addListener(
      //   () {
      //     print("ScreenShot Detected");
      //     screenShotCallBack.dispose();
      //   },
      // );

      emit(HomeLoadedState(universities));
    });
  }
}
