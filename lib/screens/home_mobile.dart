import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:al_bayan_quran/screens/list/juzs_list.dart';
import 'package:al_bayan_quran/screens/list/sura_list.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/audio/audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'list/juzs_list_desktop.dart';
import 'list/surah_list_desktop.dart';
import 'profile/profile.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

int currentIndex = 0;

class _HomeMobileState extends State<HomeMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width > 720
          ? null
          : SalomonBottomBar(
              selectedItemColor: Colors.green,
              currentIndex: currentIndex,
              onTap: (i) => setState(() => currentIndex = i),
              items: [
                SalomonBottomBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(
                      FontAwesomeIcons.bookOpen,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    "Quran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(Icons.audiotrack_outlined),
                  ),
                  title: const Text(
                    "Audio",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(Icons.person),
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
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
              bottom: MediaQuery.of(context).size.width > 720
                  ? null
                  : const TabBar(
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 720) {
                  return const Row(
                    children: [
                      Expanded(
                        child: SuraListDesktop(),
                      ),
                      Expanded(
                        child: JuzsListDesktop(),
                      ),
                    ],
                  );
                } else {
                  return const TabBarView(
                    children: [
                      SuraList(),
                      JuzsList(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        const Audio(),
        const Profile(),
      ].elementAt(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: MediaQuery.of(context).size.width > 720
          ? FloatingActionButton.extended(
              onPressed: null,
              label: SalomonBottomBar(
                currentIndex: currentIndex,
                onTap: (i) => setState(() => currentIndex = i),
                selectedItemColor: const Color.fromARGB(255, 0, 207, 7),
                items: [
                  SalomonBottomBarItem(
                    icon: const Icon(FontAwesomeIcons.book),
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
            )
          : null,
    );
  }
}
