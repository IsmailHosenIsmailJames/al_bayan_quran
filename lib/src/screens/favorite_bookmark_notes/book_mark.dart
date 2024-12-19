import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../drawer/drawer.dart';
import 'get_data.dart';

class BookMark extends StatelessWidget {
  const BookMark({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = buildWidgetForFavBook(
      "bookmark",
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Mark".tr),
      ),
      drawer: const MyDrawer(),
      body: list.isEmpty
          ? Center(
              child: Text("Empty".tr),
            )
          : ListView(),
    );
  }
}
