import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../drawer/drawer.dart';
import 'get_data.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = buildWidgetForFavBook("favorite");
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite".tr),
      ),
      drawer: const MyDrawer(),
      body: list.isEmpty
          ? Center(
              child: Text("Empty".tr),
            )
          : ListView(
              children: list,
            ),
    );
  }
}
