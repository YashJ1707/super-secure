import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_secure/buisness_logic/home_bloc/home_bloc.dart';
import 'package:super_secure/data/list.dart';
import 'package:super_secure/data/models/data_model.dart';
import 'package:super_secure/presentation/archive_page.dart';
import 'package:super_secure/widgets/list_tile.dart';

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
              appBar: getAppBar(context),
              body: buildListView(),
            );
          }

          return Container();
        },
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
        itemCount: UniversityList.universitiesList.length,
        itemBuilder: ((context, index) {
          final item = UniversityList.universitiesList[index];
          return buildSlidableTile(item, context, index);
        }));
  }

  Slidable buildSlidableTile(University item, BuildContext context, int index) {
    return Slidable(
        key: Key(item.name.toString()),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            context.read<HomeBloc>().add(DeleteListItemEvent(index));
          }),
          children: [
            SlidableAction(
              onPressed: ((context) {
                context.read<HomeBloc>().add(DeleteListItemEvent(index));
              }),
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
          dismissible: DismissiblePane(onDismissed: (() {
            context.read<HomeBloc>().add(ArchiveListItemEvent(index));
          })),
          children: [
            SlidableAction(
              onPressed: ((context) {
                context.read<HomeBloc>().add(ArchiveListItemEvent(index));
              }),
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
          ],
        ),
        child: buildListTile(item));
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ArchivePage()));
          },
          icon: const Icon(Icons.archive)),
      toolbarHeight: 50,
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
