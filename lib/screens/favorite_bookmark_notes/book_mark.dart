import 'package:flutter/material.dart';

import '../drawer/drawer.dart';
import 'get_data.dart';

class BookMark extends StatelessWidget {
  const BookMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookMark"),
      ),
      drawer: const MyDrawer(),
      body: ListView(
        children: buildWidgetForFavBook(
          "bookmark",
        ),
      ),
    );
  }
}
