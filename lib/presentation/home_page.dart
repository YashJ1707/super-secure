import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_secure/buisness_logic/home_bloc/home_bloc.dart';
import 'package:super_secure/data/models/data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _requestPermission() async {
    var result = await Permission.locationWhenInUse.request();
    if (result.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission() async {
    if (await Permission.locationWhenInUse.serviceStatus !=
        ServiceStatus.enabled) {
      // var locationResponse = ;
      if (await Location.instance.requestService() != true) {
        locationPrompt(context);
      }
    }
    var granted = await _requestPermission();
    if (granted != true) {
      requestLocationPermission();
    }
    return granted;
  }

  @override
  void initState() {
    var loc = requestLocationPermission();
    Location.instance.onLocationChanged.listen((event) async {
      if (await Permission.locationWhenInUse.serviceStatus ==
          ServiceStatus.disabled) {
        locationPrompt(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadApiEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (state is HomeLoadedState) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 40,
                elevation: 2,
                centerTitle: true,
                title: const Text("Data"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(ScreenShotEvent());
                    },
                    child: const Text("ScreenShot"),
                  ),
                ],
              ),
              body: ListView.builder(
                  itemCount: state.universities.length,
                  itemBuilder: ((context, index) {
                    final item = state.universities[index];
                    return Slidable(
                        key: Key(item.name.toString()),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: const [
                            SlidableAction(
                              onPressed: null,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),

                        // ignore: prefer_const_constructors
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          // dismissible: DismissiblePanes
                          children: const [
                            SlidableAction(
                              onPressed: null,
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Archive',
                            ),
                          ],
                        ),
                        child: buildListTile(item));
                  })),
            );
          }

          return Container();
        },
      ),
    );
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

  locationPrompt(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () async {
        if (await Location.instance.requestService() == false) {
          exit(0);
        } else {
          Navigator.pop(context);
        }
      },
    );
    Widget exitButton = TextButton(
      child: const Text("Exit"),
      onPressed: () {
        exit(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Enable Location"),
      content: const Text("This app requires location to run."),
      actions: [
        exitButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
