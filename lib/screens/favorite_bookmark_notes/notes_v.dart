import 'package:flutter/material.dart';

import '../drawer/drawer.dart';
import 'notes_get_data.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = buildListOfWidgetForNotes();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: ListView(
        children: list.length == 0
            ? [
                Center(
                  child: Text("No Notes found"),
                )
              ]
            : list,
      ),
    );
  }
}
