import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../api/all_recitation.dart';
import '../api/by_juzs.dart';
import '../api/some_api_response.dart';
import 'profile/profile.dart';
import 'surah_view.dart/sura_view.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

int currentIndex = 0;

class _HomeMobileState extends State<HomeMobile> with TickerProviderStateMixin {
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();
  String currentReciter = "";
  int playingIndex = -1;
  int surahNumber = -1;

  List<DropdownMenuEntry<Object>> dropdownList = [];

  List<int> expandedPosition = [];
  List<AnimationController> controller = [];
  List<Animation<double>> sizeAnimation = [];

  @override
  void initState() {
    for (String recitor in allRecitation) {
      dropdownList.add(
        DropdownMenuEntry(
          value: recitor,
          label: recitor.split("(")[0],
        ),
      );
    }
    final infoBox = Hive.box("info");
    final info = infoBox.get("info", defaultValue: false);

    currentReciter = info['recitation_ID'];

    player.playerStateStream.listen((event) {
      if (player.processingState == ProcessingState.completed ||
          player.playing == false) {
        setState(() {
          isPlaying = false;
        });
      }
      if (player.processingState == ProcessingState.completed) {
        if (playingIndex >= 113) {
          setState(() {
            playingIndex = -1;
          });
        } else {
          playAudio(playingIndex + 1, wait: true);
        }
      }
    });

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

  List<Widget> listSurahProviderDesktop(length) {
    List<Widget> listSurah = [];

    for (int index = -1; index < length; index++) {
      if (index == -1) {
        listSurah.add(
          const Center(
            child: Text(
              "Surah",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );
        continue;
      }
      String revelationPlace = allChaptersInfo[index]['revelation_place'];
      String nameSimple = allChaptersInfo[index]['name_simple'];
      String nameArabic = allChaptersInfo[index]['name_arabic'];
      int versesCount = allChaptersInfo[index]['verses_count'];
      listSurah.add(
        GestureDetector(
          onTap: () async {
            await Hive.openBox("translation");
            await Hive.openBox("quran");
            player.dispose();
            setState(() {
              isPlaying = false;
              playingIndex = -1;
            });
            await Get.to(() {
              return SuraView(
                surahNumber: index,
                surahName: nameSimple,
              );
            });
            player = AudioPlayer();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: const Color.fromARGB(30, 125, 125, 125),
                borderRadius: BorderRadius.circular(15)),
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
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
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
        ),
      );
    }
    return listSurah;
  }

  List<Widget> buildJuzs(int length) {
    List<Widget> toReturn = [];
    for (int index = -1; index < length; index++) {
      if (index == -1) {
        toReturn.add(const Center(
          child: Text(
            "Juzs",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        continue;
      }
      int firstVerseId = byJuzs[index]['fvi'];
      int lastVerseId = byJuzs[index]['lvi'];

      String allSurahName = "";
      String lastSurahName = "";

      Map<String, String> myMap = Map<String, String>.from(byJuzs[index]['vm']);

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

      toReturn.add(
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
          decoration: BoxDecoration(
            color: const Color.fromARGB(30, 125, 125, 125),
            borderRadius: BorderRadius.circular(15),
          ),
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
                          backgroundColor: const Color.fromARGB(195, 0, 133, 4),
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
        ),
      );
    }
    return toReturn;
  }

  void playAudio(int index, {bool start = false, bool wait = false}) async {
    setState(() {
      surahNumber = index;
    });

    List<String> listOfURL = getAllAudioUrl();
    if (playingIndex != index || start) {
      if (wait) {
        await Future.delayed(const Duration(seconds: 1));
      }
      try {
        List<AudioSource> audioResourceSource = [];
        final surahNameSimple = allChaptersInfo[surahNumber]['name_simple'];

        for (int i = 0; i < listOfURL.length; i++) {
          audioResourceSource.add(
            LockCachingAudioSource(
              Uri.parse(listOfURL[i]),
              tag: MediaItem(
                displayTitle: "$surahNameSimple - ${i + 1} ",
                displaySubtitle: currentReciter.split("(")[0],
                id: "$i",
                title: currentReciter.split('(')[0],
                displayDescription: listOfURL[i],
              ),
            ),
          );
        }
        final playlist = ConcatenatingAudioSource(
          shuffleOrder: DefaultShuffleOrder(),
          children: audioResourceSource,
        );
        await player.setAudioSource(
          playlist,
        );
        player.play();
        setState(() {
          playingIndex = index;
          isPlaying = true;
        });
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "An error occoured",
            ),
            content: const Text(
                "Need stable internet connection for play audio for the first time."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else if (index == playingIndex && player.playing == false) {
      player.play();
      setState(() {
        playingIndex = index;
        isPlaying = true;
      });
    } else {
      player.pause();
    }
  }

  List<Widget> listSurahProviderForAudio(length) {
    List<Widget> listSurah = [];

    for (int index = 0; index < length; index++) {
      String revelationPlace = allChaptersInfo[index]['revelation_place'];
      String nameSimple = allChaptersInfo[index]['name_simple'];
      String nameArabic = allChaptersInfo[index]['name_arabic'];
      int versesCount = allChaptersInfo[index]['verses_count'];
      listSurah.add(
        GestureDetector(
          onTap: () {
            if (player.playing) {
              player.pause();
              setState(() {
                isPlaying = false;
              });
            } else {
              playAudio(index);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: const Color.fromARGB(30, 125, 125, 125),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color.fromARGB(195, 0, 133, 4),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: playingIndex == index && isPlaying
                          ? const Icon(
                              Icons.pause_rounded,
                              size: 30,
                              color: Color.fromARGB(195, 0, 133, 4),
                            )
                          : const Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                              color: Color.fromARGB(195, 0, 133, 4),
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
        ),
      );
    }
    return listSurah;
  }

  List<String> getAllAudioUrl() {
    int start = 0;
    int end = allChaptersInfo[surahNumber]['verses_count'];
    List<String> listOfURL = [];
    for (int i = start; i < end; i++) {
      listOfURL.add(getFullURL(i + 1));
    }
    return listOfURL;
  }

  String getBaseURLOfAudio(String recitor) {
    List<String> splited = recitor.split("(");
    String urlID = splited[1].replaceAll(")", "");
    String audioBaseURL = "https://everyayah.com/data/$urlID";
    return audioBaseURL;
  }

  String getIdOfAudio(int ayahNumber) {
    String suraString = "";
    if (surahNumber < 10) {
      suraString = "00${surahNumber + 1}";
    } else if (surahNumber + 1 < 100) {
      suraString = "0${surahNumber + 1}";
    } else {
      suraString = (surahNumber + 1).toString();
    }
    String ayahString = "";

    if (ayahNumber < 10) {
      ayahString = "00$ayahNumber";
    } else if (ayahNumber < 100) {
      ayahString = "0$ayahNumber";
    } else {
      ayahString = ayahNumber.toString();
    }
    return suraString + ayahString;
  }

  int getAyahCountFromStart(int ayahNumber) {
    for (int i = 0; i < surahNumber; i++) {
      int verseCount = allChaptersInfo[i]['verses_count'];
      ayahNumber += verseCount;
    }
    return ayahNumber;
  }

  String getFullURL(int ayahNumber) {
    String recitorChoice = currentReciter;
    String baseURL = getBaseURLOfAudio(recitorChoice);
    String audioID = getIdOfAudio(ayahNumber);
    return "$baseURL/$audioID.mp3";
  }

  List<Widget> listSurahProvider(length) {
    List<Widget> listSurah = [];

    for (int index = 0; index < length; index++) {
      String revelationPlace = allChaptersInfo[index]['revelation_place'];
      String nameSimple = allChaptersInfo[index]['name_simple'];
      String nameArabic = allChaptersInfo[index]['name_arabic'];
      int versesCount = allChaptersInfo[index]['verses_count'];
      listSurah.add(
        GestureDetector(
          onTap: () async {
            player.dispose();
            setState(() {
              isPlaying = false;
              playingIndex = -1;
            });
            await Hive.openBox("translation");
            await Hive.openBox("quran");
            await Get.to(() {
              return SuraView(
                surahNumber: index,
                surahName: nameSimple,
              );
            });
            player = AudioPlayer();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: const Color.fromARGB(30, 125, 125, 125),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(195, 0, 133, 4),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
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
        ),
      );
    }
    return listSurah;
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
          player.dispose();
          setState(() {
            isPlaying = false;
            playingIndex = -1;
          });
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

          await Get.to(() => SuraView(
                surahNumber: surahNumber,
                start: startFrom,
                end: endTo,
              ));
          player = AudioPlayer();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
          decoration: BoxDecoration(
              color: const Color.fromARGB(30, 125, 125, 125),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(195, 0, 168, 6),
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

  @override
  void dispose() async {
    await player.dispose();
    for (int i = 0; i < 30; i++) {
      controller[i].dispose();
    }
    scrollController.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget dropdown = Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 5,
        top: 5,
      ),
      child: DropdownMenu(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        menuHeight: 300,
        label: const Text("All Reciters List"),
        onSelected: (value) {
          setState(() {
            currentReciter = value.toString();
          });
          if (playingIndex != -1) {
            playAudio(playingIndex, start: true);
          }
        },
        dropdownMenuEntries: dropdownList,
      ),
    );
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
                  return Row(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 50),
                          children: listSurahProviderDesktop(114),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 50),
                          children: buildJuzs(byJuzs.length),
                        ),
                      ),
                    ],
                  );
                } else {
                  return TabBarView(
                    children: [
                      Scrollbar(
                        interactive: true,
                        radius: const Radius.circular(10),
                        thickness: 10,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 50, top: 5),
                          children: listSurahProvider(114),
                        ),
                      ),
                      ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
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
                              allSurahName.length - 2,
                              allSurahName.length - 1,
                              "");

                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 125, 125, 125),
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    195, 0, 133, 4),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${lastVerseId - firstVerseId} Ayahs",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 136, 136, 136),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:
                                                index == expandedPosition[index]
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
                    ],
                  );
                }
              },
            ),
          ),
        ),
        Scaffold(
          drawer: const MyDrawer(),
          appBar: AppBar(
            title: const Text(
              "Audio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (MediaQuery.of(context).size.width <= 720) dropdown,
              if (MediaQuery.of(context).size.width <= 720)
                Expanded(
                  child: ListView(children: listSurahProviderForAudio(114)),
                ),
              if (MediaQuery.of(context).size.width > 720)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: dropdown,
                      ),
                      Expanded(
                        child: ListView(
                          children: listSurahProviderForAudio(114),
                        ),
                      ),
                    ],
                  ),
                ),
              Text(currentReciter.split("(")[0]),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 80,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(30, 125, 125, 125),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: "Jump to Previous Surah",
                      onPressed: playingIndex < 0
                          ? null
                          : () {
                              playAudio(playingIndex - 1);
                            },
                      icon: const Icon(
                        Icons.navigate_before_rounded,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      tooltip: "Jump to Previous Ayah",
                      onPressed: () {
                        player.seekToPrevious();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      tooltip: "Play Or Pause",
                      onPressed: () async {
                        if (playingIndex != -1) {
                          if (player.playing) {
                            player.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            player.play();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        } else {
                          playAudio(0);
                        }
                      },
                      icon: isPlaying
                          ? const Icon(
                              Icons.pause_rounded,
                              size: 55,
                            )
                          : const Icon(
                              Icons.play_arrow_rounded,
                              size: 55,
                            ),
                    ),
                    IconButton(
                      tooltip: "Jump to Next Ayah",
                      onPressed: () {
                        player.seekToNext();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      tooltip: "Jump to Next Surah",
                      onPressed: playingIndex >= 113
                          ? null
                          : () async {
                              playAudio(playingIndex + 1);
                            },
                      icon: const Icon(
                        Icons.navigate_next_rounded,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Profile(),
      ].elementAt(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: MediaQuery.of(context).size.width > 720
          ? FloatingActionButton.extended(
              onPressed: null,
              extendedPadding: EdgeInsets.zero,
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
