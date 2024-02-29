import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:al_bayan_quran/screens/list/juzs_list.dart';
import 'package:al_bayan_quran/screens/list/sura_list.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/audio/audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'profile/profile.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: Colors.green,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(
              FontAwesomeIcons.bookOpen,
              size: 20,
            ),
            title: const Text("Quran"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.audiotrack_outlined),
            title: const Text("Audio"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
          ),
        ],
      ),
      body: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: const MyDrawer(),
            appBar: AppBar(
              title: const Text(
                "Al Quran",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: const [
                // IconButton(
                //     onPressed: () {
                //       showDialog(
                //         useSafeArea: true,
                //         context: context,
                //         builder: (context) => AlertDialog(
                //           title: const Row(
                //             children: [
                //               Icon(Icons.search),
                //               SizedBox(
                //                 width: 15,
                //               ),
                //               Text("Search")
                //             ],
                //           ),
                //           content: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               TextFormField(
                //                 autofocus: true,
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 8.0),
                //                 child: Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceAround,
                //                     children: [
                //                       TextButton(
                //                         child: const Text("Quran"),
                //                         onPressed: () {},
                //                       ),
                //                       TextButton(
                //                           child: const Text("Translation"),
                //                           onPressed: () {}),
                //                       TextButton(
                //                           child: const Text("Tafseer"),
                //                           onPressed: () {}),
                //                     ]),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.search))
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Surah",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Juzs',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Tab(
                  //   child: Text(
                  //     'Pages',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                SuraList(),
                JuzsList(),
                // Center(
                //   child: Text("Pages"),
                // ),
              ],
            ),
          ),
        ),
        const Audio(),
        const Profile(),
      ].elementAt(currentIndex),
    );
  }
}
