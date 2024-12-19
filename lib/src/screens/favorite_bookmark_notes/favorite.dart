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
      body: ListView(
        children: list.isEmpty
            ? [
                const Center(
                  child: Text("No Favorite Found."),
                )
              ]
            : list,
      ),
    );
  }
}
