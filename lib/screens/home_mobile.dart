import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:al_bayan_quran/screens/list/juzs_list.dart';
import 'package:al_bayan_quran/screens/list/pages_list.dart';
import 'package:al_bayan_quran/screens/list/sura_list.dart';
import 'package:flutter/material.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          controller: scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text("Al Bayan Quran"),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Sura",
                  ),
                  Tab(
                    text: "Juzs",
                  ),
                  Tab(
                    text: "Pages",
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Search")
                            ],
                          ),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                autofocus: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        child: const Text("Quran"),
                                        onPressed: () {},
                                      ),
                                      TextButton(
                                          child: const Text("Translation"),
                                          onPressed: () {}),
                                      TextButton(
                                          child: const Text("Tafseer"),
                                          onPressed: () {}),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search))
              ],
            )
          ],
          body: const TabBarView(
            children: [
              SuraList(),
              JuzsList(),
              PagesList(),
            ],
          ),
        ),
      ),
    );
  }
}
