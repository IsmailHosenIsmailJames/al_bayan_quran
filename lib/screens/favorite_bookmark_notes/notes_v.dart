import 'package:flutter/material.dart';

import '../drawer/drawer.dart';
import 'notes_get_data.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: ListView(
        children: buildListOfWidgetForNotes(),
      ),
    );
  }
}
