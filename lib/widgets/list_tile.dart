import 'package:flutter/material.dart';
import 'package:super_secure/data/models/data_model.dart';

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
