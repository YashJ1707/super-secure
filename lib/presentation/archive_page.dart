import 'package:flutter/material.dart';
import 'package:super_secure/data/list.dart';
import 'package:super_secure/widgets/list_tile.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          elevation: 2,
          centerTitle: true,
          title: const Text("Archives"),
        ),
        body: ListView.builder(
            itemCount: UniversityList.archivedUniversitiesList.length,
            itemBuilder: ((context, index) {
              final item = UniversityList.archivedUniversitiesList[index];
              return buildListTile(item);
            })));
  }
}
