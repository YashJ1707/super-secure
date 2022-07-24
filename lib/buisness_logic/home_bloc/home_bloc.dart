import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
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
      List<University> universities =
          await WebPagesRepository().getWebPageModelFromRawData();
      emit(HomeLoadedState(universities));
    });

    on<ScreenShotEvent>((event, emit) async {
      try {
        var position = await GeolocatorPlatform.instance.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high));
        // print("initiated");
        await FirebaseFirestore.instance
            .collection('location')
            .add({'location': GeoPoint(position.latitude, position.longitude)});
      } catch (e) {
        print(e);
      }
    });
    on<DeleteListItemEvent>(((event, emit) async {}));
  }
}
