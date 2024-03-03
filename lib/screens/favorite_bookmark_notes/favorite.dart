import 'package:flutter/material.dart';
import 'get_data.dart';

class Favorite extends StatelessWidget {
  final String name;
  const Favorite({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return getListView(name);
  }
}
