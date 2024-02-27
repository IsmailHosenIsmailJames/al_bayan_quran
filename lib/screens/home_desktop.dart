import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:al_bayan_quran/screens/list/juzs_list_desktop.dart';
import 'package:al_bayan_quran/screens/list/surah_list_desktop.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'profile/profile_desktop.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: SalomonBottomBar(
          margin: const EdgeInsets.only(left: 10, right: 10),
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          selectedItemColor: const Color.fromARGB(255, 0, 207, 7),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.book),
              title: const Text("Quran"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Al Bayan Quran"),
      ),
      body: [
        const Row(
          children: [
            Expanded(
              child: SuraListDesktop(),
            ),
            Expanded(
              child: JuzsListDesktop(),
            ),
          ],
        ),
        const ProfileDesktop(),
      ].elementAt(currentIndex),
    );
  }
}
