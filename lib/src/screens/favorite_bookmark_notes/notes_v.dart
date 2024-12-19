import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../drawer/drawer.dart';
import 'notes_get_data.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = buildListOfWidgetForNotes();
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Text("Notes".tr),
      ),
      body: ListView(
        children: list.isEmpty
            ? [
                const Center(
                  child: Text("No Notes found"),
                )
              ]
            : list,
      ),
    );
  }
}
