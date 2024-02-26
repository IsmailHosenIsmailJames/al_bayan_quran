import 'package:al_bayan_quran/screens/list/juzs_list.dart';
import 'package:al_bayan_quran/screens/list/surah_list_desktop.dart';
import 'package:flutter/material.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Al Bayan Quran"),
            Spacer(),
            Text("Surah - Juzs - Pages"),
            Spacer(),
          ],
        ),
      ),
      body: const Row(
        children: [
          Expanded(
            child: SuraListDesktop(),
          ),
          Expanded(
            child: JuzsList(),
          ),
        ],
      ),
    );
  }
}
