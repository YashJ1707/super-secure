import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:super_secure/buisness_logic/home_bloc/home_bloc.dart';
import 'package:super_secure/data/models/data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  // final Permission permissionHandler = Permission;
  // Future<bool> _requestPermission() async {
  //   var result = await Permission.locationWhenInUse.request();
  //   if (result.isGranted) {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<bool> requestLocationPermission() async {
  //   var granted = await _requestPermission();
  //   if (granted != true) {
  //     requestLocationPermission();
  //   }
  //   debugPrint('requestContactsPermission $granted');
  //   return granted;
  // }

  @override
  void initState() {
    // requestLocationPermission();
    screenListener.addScreenRecordListener((recorded) {});

    screenListener.addScreenShotListener((filePath) {
      print("ss");
    });

    ///You can add multiple listener ^-^
    screenListener.addScreenRecordListener((recorded) {
      print("Hi i'm 2nd Screen Record listener");
    });

    ///Start watch
    screenListener.watch();
    screenListener.preventAndroidScreenShot(false);
    super.initState();
  }

  @override
  void dispose() {
    //dispose the observer after use
    screenListener.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeBloc()..add(LoadApiEvent()),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            elevation: 2,
            centerTitle: true,
            title: const Text("Data"),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeLoadedState) {
                // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
                return ListView.builder(
                    itemCount: state.universities.length,
                    itemBuilder: ((context, index) {
                      final item = state.universities[index];
                      return Slidable(
                          key: Key(item.name.toString()),
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () {}),

                            // All actions are defined in the children parameter.
                            children: const [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: null,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              // print(FlutterWindowManager.FLAG)
                            }),
                            children: const [
                              SlidableAction(
                                // An action can be bigger than the others.
                                // flex: 2,
                                onPressed: null,
                                backgroundColor: Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.archive,
                                label: 'Archive',
                              ),
                            ],
                          ),
                          child: buildListTile(item));
                    }));
              }

              return Container();
            },
          ),
        ));
  }

  Card buildListTile(University item) {
    return Card(
      elevation: 6,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          item.name.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        selectedTileColor: Colors.amber,
        subtitle: Text(
          item.domains!.first.toLowerCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
