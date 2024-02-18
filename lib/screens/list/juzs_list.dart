import 'package:al_bayan_quran/api/some_api_response.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/sura_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../api/by_juzs.dart';

class JuzsList extends StatefulWidget {
  const JuzsList({super.key});

  @override
  State<JuzsList> createState() => _JuzsListState();
}

class _JuzsListState extends State<JuzsList> with TickerProviderStateMixin {
  List<int> expandedPosition = [];
  List<AnimationController> controller = [];
  List<Animation<double>> sizeAnimation = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      final tem = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );
      controller.add(tem);
      sizeAnimation.add(CurvedAnimation(parent: tem, curve: Curves.easeInOut));
      expandedPosition.add(-1);
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 30; i++) {
      controller[i].dispose();
    }
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      trackVisibility: true,
      thickness: 10,
      thumbVisibility: true,
      radius: const Radius.circular(10),
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: byJuzs.length,
        itemBuilder: (context, index) {
          int firstVerseId = byJuzs[index]['fvi'];
          int lastVerseId = byJuzs[index]['lvi'];

          String allSurahName = "";
          String lastSurahName = "";

          Map<String, String> myMap =
              Map<String, String>.from(byJuzs[index]['vm']);

          myMap.forEach((key, value) {
            int i = int.parse(key) - 1;

            if (allSurahName.isNotEmpty) {
              lastSurahName = allChaptersInfo[i]['name_simple'];
            } else {
              allSurahName += allChaptersInfo[i]['name_simple'];
            }
          });
          if (lastSurahName.isNotEmpty) {
            allSurahName = "$allSurahName - $lastSurahName";
          }
          allSurahName = allSurahName.replaceRange(
              allSurahName.length - 2, allSurahName.length - 1, "");

          return Container(
            padding: const EdgeInsets.all(10),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      expandedPosition[index] == index
                          ? {
                              expandedPosition[index] = -1,
                              controller[index].reverse()
                            }
                          : {
                              expandedPosition[index] = index,
                              controller[index].forward()
                            };
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allSurahName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Total ${myMap.length} Surah",
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${lastVerseId - firstVerseId} Ayahs",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 136, 136, 136),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: index == expandedPosition[index]
                                ? const Icon(
                                    Icons.arrow_drop_down,
                                    key: Key("1"),
                                  )
                                : const Icon(
                                    Icons.arrow_drop_up,
                                    key: Key("2"),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: sizeAnimation[index],
                  axis: Axis.vertical,
                  child: Column(
                    key: const Key("2"),
                    children: surahUnderJuzs(index),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> surahUnderJuzs(int index) {
    List<Widget> listOfWidget = [];
    Map<String, String> myMap = Map<String, String>.from(byJuzs[index]['vm']);
    myMap.forEach((key, value) {
      int surahNumber = int.parse(key) - 1;
      String revelationPlace = allChaptersInfo[surahNumber]['revelation_place'];
      String nameSimple = allChaptersInfo[surahNumber]['name_simple'];
      String nameArabic = allChaptersInfo[surahNumber]['name_arabic'];
      var versesCount = allChaptersInfo[surahNumber]['verses_count'];
      List<String> startEnd = value.split('-');
      int startEndDiffenrence =
          int.parse(startEnd[1]) - int.parse(startEnd[0]) + 1;
      if (startEndDiffenrence != versesCount) {
        versesCount = "${startEnd[0]} : ${startEnd[1]}";
      }
      listOfWidget.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          List<String> splited =
              versesCount.toString().replaceAll(" ", "").split(":");
          int startFrom = 0;
          int endTo = 0;
          if (splited.length > 1) {
            startFrom = int.parse(splited[0]);
            endTo = int.parse(splited[1]);
          } else {
            endTo = int.parse(splited[0]);
          }
          await Hive.openBox("translation");
          await Hive.openBox("quran");

          Get.to(() => SuraView(
                surahNumber: surahNumber,
                start: startFrom,
                end: endTo,
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(195, 0, 133, 4),
                    child: Center(
                      child: Text(
                        (surahNumber + 1).toString(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameSimple,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          revelationPlace,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 136, 136, 136),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    nameArabic,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "$versesCount Ayahs",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 136, 136, 136),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ));
    });
    return listOfWidget;
  }
}
