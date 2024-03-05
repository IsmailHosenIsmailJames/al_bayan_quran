import 'package:flutter/material.dart';

import '../drawer/drawer.dart';
import 'get_data.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
      ),
      drawer: const MyDrawer(),
      body: ListView(
        children: buildWidgetForFavBook("favorite"),
      ),
    );
  }
}
