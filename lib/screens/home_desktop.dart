import 'package:al_bayan_quran/screens/list/juzs_list.dart';
import 'package:al_bayan_quran/screens/list/page_list_desktop.dart';
import 'package:al_bayan_quran/screens/list/sura_list.dart';
import 'package:flutter/material.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
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
      body: Row(
        children: [
          const Expanded(
            child: SuraList(),
          ),
          const Expanded(
            child: JuzsList(),
          ),
          if (MediaQuery.of(context).size.width > 1000)
            const Expanded(
              child: PagesListDesktop(),
            ),
        ],
      ),
    );
    // DefaultTabController(
    //   length: 3,
    //   child: Scaffold(
    //     drawer: const MyDrawer(),
    //     body: NestedScrollView(
    //       floatHeaderSlivers: true,
    //       headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //         SliverAppBar(
    //           floating: true,
    //           snap: true,
    //           title: const Text("Al Bayan Quran"),
    //           bottom: const TabBar(
    //             tabs: [
    //               Tab(
    //                 text: "Sura",
    //               ),
    //               Tab(
    //                 text: "Juzs",
    //               ),
    //               Tab(
    //                 text: "Pages",
    //               ),
    //             ],
    //           ),
    //           actions: [
    //             IconButton(
    //                 onPressed: () {
    //                   showDialog(
    //                     useSafeArea: true,
    //                     context: context,
    //                     builder: (context) => AlertDialog(
    //                       title: const Row(
    //                         children: [
    //                           Icon(Icons.search),
    //                           SizedBox(
    //                             width: 15,
    //                           ),
    //                           Text("Search")
    //                         ],
    //                       ),
    //                       content: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           TextFormField(
    //                             autofocus: true,
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(top: 8.0),
    //                             child: Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceAround,
    //                                 children: [
    //                                   TextButton(
    //                                     child: const Text("Quran"),
    //                                     onPressed: () {},
    //                                   ),
    //                                   TextButton(
    //                                       child: const Text("Translation"),
    //                                       onPressed: () {}),
    //                                   TextButton(
    //                                       child: const Text("Tafseer"),
    //                                       onPressed: () {}),
    //                                 ]),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //                 icon: const Icon(Icons.search))
    //           ],
    //         )
    //       ],
    //       body:
    //     ),
    //   ),
    // );
  }
}
