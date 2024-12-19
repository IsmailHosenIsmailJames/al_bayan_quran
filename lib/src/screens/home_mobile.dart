import 'package:al_quran/src/collect_info/getx/get_controller.dart';
import 'package:al_quran/src/screens/drawer/settings_with_appbar.dart';
import 'package:al_quran/src/screens/favorite_bookmark_notes/book_mark.dart';
import 'package:al_quran/src/screens/favorite_bookmark_notes/favorite.dart';
import 'package:al_quran/src/screens/favorite_bookmark_notes/notes_v.dart';
import 'package:al_quran/src/screens/platforms/others_platform.dart';
import 'package:appwrite/appwrite.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/all_recitation.dart';
import '../api/by_juzs.dart';
import '../api/some_api_response.dart';
import '../auth/account_info/account_info.dart';
import '../auth/login/login.dart';
import '../theme/theme_controller.dart';
import '../theme/theme_icon_button.dart';
import 'profile/profile.dart';
import 'surah_view.dart/sura_view.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

int currentIndex = 0;

class _HomeMobileState extends State<HomeMobile> with TickerProviderStateMixin {
  final SidebarXController _sidebarXController =
      SidebarXController(selectedIndex: 0);
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();
  String currentReciter = "";
  int playingIndex = -1;
  int surahNumber = -1;

  List<DropdownMenuEntry<Object>> dropdownList = [];

  List<int> expandedPosition = [];
  List<AnimationController> controller = [];
  List<Animation<double>> sizeAnimation = [];

  final infoController = Get.put(InfoController());
  final infoBox = Hive.box("info");

  @override
  void initState() {
    for (String rector in allRecitation) {
      dropdownList.add(
        DropdownMenuEntry(
          value: rector,
          label: rector.split("(")[0],
        ),
      );
    }
    final info = infoBox.get("info", defaultValue: false);

    currentReciter = info['recitation_ID'];

    player.playerStateStream.listen((event) async {
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
            isPlaying = false;
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

    _sidebarXController.extendStream.listen((event) {
      setState(() {
        isExtended = event;
      });
    });
    openBoxes();
  }

  bool isExtended = false;

  Future<void> openBoxes() async {
    final tem = Hive.box("info");
    if (Hive.isBoxOpen(
            tem.get("quranScriptType", defaultValue: "quran_tajweed")) ==
        false) {
      await Hive.openBox(
          tem.get("quranScriptType", defaultValue: "quran_tajweed"));
    }
  }

  List<Widget> listSurahProviderDesktop(length) {
    List<Widget> listSurah = [];

    for (int index = -1; index < length; index++) {
      if (index == -1) {
        listSurah.add(
          Center(
            child: Text(
              "Surah".tr,
              style: const TextStyle(
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
            await openBoxes();
            await Hive.openBox("translation");
            await Hive.openBox("quran");
            final tem = Hive.box("info");
            await Hive.openBox(
                tem.get("quranScriptType", defaultValue: "quran_tajweed"));
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
            color: const Color.fromARGB(20, 125, 125, 125),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await openBoxes();

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
              "An error occurred",
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
            if (playingIndex == index) {
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
              playAudio(index);
              setState(() {
                playingIndex = index;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: const Color.fromARGB(20, 125, 125, 125),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(15),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color.fromARGB(255, 0, 140, 255),
                      child: playingIndex == index && isPlaying
                          ? const Icon(
                              Icons.pause_rounded,
                              size: 25,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.play_arrow_rounded,
                              size: 25,
                              color: Colors.white,
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
    String recitorChoice =
        infoBox.get("info")['recitation_ID'] ?? currentReciter;
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
            await openBoxes();
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
                color: const Color.fromARGB(20, 125, 125, 125),
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
              color: const Color.fromARGB(20, 125, 125, 125),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade700,
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
    Widget myDrawer = Drawer(
      child: ListView(
        padding: const EdgeInsets.only(
          right: 10,
          bottom: 20,
        ),
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isLoggedIn
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(() => const LogIn());
                              },
                              label: Text(
                                "LogIn".tr,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                ),
                              ),
                              icon: const Icon(
                                Icons.login,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                "loginReason".tr,
                                style: const TextStyle(fontSize: 9),
                              ),
                            )
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green,
                            child: GetX<AccountInfo>(
                              builder: (controller) => Text(
                                controller.name.value.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.name.value.length > 10
                                      ? "${controller.name.value.substring(0, 10)}..."
                                      : controller.name.value,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.email.value.length > 20
                                      ? "${controller.email.value.substring(0, 15)}...${controller.email.value.substring(controller.email.value.length - 9, controller.email.value.length)}"
                                      : controller.email.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.uid.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                themeIconButton,
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.home_rounded,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Home".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");
              await player.dispose();
              await Get.to(
                () => const Favorite(),
              );
              player = AudioPlayer();
              setState(() {
                playingIndex = -1;
                surahNumber = -1;
                isPlaying = false;
              });
            },
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Favorite".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");
              await player.dispose();
              await Get.to(() => const BookMark());
              player = AudioPlayer();
              setState(() {
                playingIndex = -1;
                surahNumber = -1;
                isPlaying = false;
              });
            },
            child: Row(
              children: [
                const Icon(
                  Icons.bookmark_added,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Book Mark".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");
              await Hive.openBox("notes");
              await player.dispose();
              await Get.to(() => const NotesView());
              player = AudioPlayer();
              setState(() {
                playingIndex = -1;
                surahNumber = -1;
                isPlaying = false;
              });
            },
            child: Row(
              children: [
                const Icon(
                  Icons.note_add,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Notes".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox("translation");
              await Hive.openBox(quranScriptType);
              await player.dispose();
              await Get.to(() => const SettingsWithAppbar());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Settings".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OthersPlatform(),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(
                  FluentIcons.phone_laptop_16_filled,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Others Platforms".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (isLoggedIn)
            TextButton(
              onPressed: () async {
                Client client = Client()
                    .setEndpoint("https://cloud.appwrite.io/v1")
                    .setProject("albayanquran");
                Account account = Account(client);
                await account.deleteSession(sessionId: 'current');
                setState(() {
                  isLoggedIn = false;
                });
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Log Out")
                ],
              ),
            ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(
                  "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"));
            },
            child: Row(
              children: [
                const Icon(
                  Icons.privacy_tip,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Privacy Policy".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );

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
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        menuHeight: 300,
        label: Text("All Reciters List".tr),
        onSelected: (value) {
          Map<String, String> temInfoMap =
              Map<String, String>.from(infoBox.get("info"));
          temInfoMap['recitation_ID'] = value.toString();
          infoBox.put("info", temInfoMap);
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
                  icon: Padding(
                    padding: EdgeInsets.only(
                        left: currentIndex == 0 ? 0 : 15,
                        right: currentIndex == 0 ? 0 : 15),
                    child: const Icon(
                      FontAwesomeIcons.bookOpen,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    "Al Quran".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                        left: currentIndex == 1 ? 0 : 15,
                        right: currentIndex == 1 ? 0 : 15),
                    child: const Icon(Icons.audiotrack_outlined),
                  ),
                  title: Text(
                    "Audio".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                        left: currentIndex == 2 ? 0 : 15,
                        right: currentIndex == 2 ? 0 : 15),
                    child: const Icon(Icons.person),
                  ),
                  title: Text(
                    "Profile".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
      body: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: MediaQuery.of(context).size.width > 800 ? null : myDrawer,
            appBar: MediaQuery.of(context).size.width > 800
                ? null
                : AppBar(
                    title: Text(
                      "Al Quran".tr,
                      style: const TextStyle(
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
                        : TabBar(
                            tabs: [
                              Tab(
                                child: Text(
                                  "Surah".tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Juzs'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
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
                      if (MediaQuery.of(context).size.width > 800) sidebarx,
                      Expanded(
                        flex: 3,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 50),
                          children: listSurahProviderDesktop(114),
                        ),
                      ),
                      Expanded(
                        flex: 3,
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
                        radius: const Radius.circular(7),
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
                              color: const Color.fromARGB(20, 125, 125, 125),
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
          drawer: MediaQuery.of(context).size.width > 800 ? null : myDrawer,
          appBar: MediaQuery.of(context).size.width > 800
              ? null
              : AppBar(
                  title: Text(
                    "Audio".tr,
                    style: const TextStyle(
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
                      if (MediaQuery.of(context).size.width > 800) sidebarx,
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
                height: 60,
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
                        size: 35,
                      ),
                    ),
                    IconButton(
                      tooltip: "Jump to Previous Ayah",
                      onPressed: () {
                        player.seekToPrevious();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 35,
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
                              size: 40,
                            )
                          : const Icon(
                              Icons.play_arrow_rounded,
                              size: 40,
                            ),
                    ),
                    IconButton(
                      tooltip: "Jump to Next Ayah",
                      onPressed: () {
                        player.seekToNext();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 35,
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
                        size: 35,
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
                    title: Text("Al Quran".tr),
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.audiotrack_outlined),
                    title: Text("Audio".tr),
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

  late Widget sidebarx = SidebarX(
    controller: _sidebarXController,
    theme: SidebarXTheme(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: canvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      hoverColor: scaffoldBackgroundColor,
      textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      selectedTextStyle: const TextStyle(color: Colors.white),
      itemTextPadding: const EdgeInsets.only(left: 30),
      selectedItemTextPadding: const EdgeInsets.only(left: 30),
      itemDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: canvasColor),
      ),
      selectedItemDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: actionColor.withOpacity(0.37),
        ),
        gradient: const LinearGradient(
          colors: [accentCanvasColor, canvasColor],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 30,
          )
        ],
      ),
      iconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.7),
        size: 20,
      ),
      selectedIconTheme: const IconThemeData(
        color: Color.fromARGB(255, 84, 235, 89),
        size: 20,
      ),
    ),
    extendedTheme: const SidebarXTheme(
      width: 200,
      decoration: BoxDecoration(
        color: canvasColor,
      ),
    ),
    footerDivider: divider,
    headerBuilder: isExtended
        ? (context, extended) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isLoggedIn
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(() => const LogIn());
                              },
                              label: Text(
                                "LogIn".tr,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(
                                Icons.login,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                "loginReason".tr,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green,
                            child: GetX<AccountInfo>(
                              builder: (controller) => Text(
                                controller.name.value.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.name.value.length > 10
                                      ? "${controller.name.value.substring(0, 10)}..."
                                      : controller.name.value,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.email.value.length > 20
                                      ? "${controller.email.value.substring(0, 15)}...${controller.email.value.substring(controller.email.value.length - 9, controller.email.value.length)}"
                                      : controller.email.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              GetX<AccountInfo>(
                                builder: (controller) => Text(
                                  controller.uid.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                themeIconButton,
              ],
            );
          }
        : null,
    items: [
      SidebarXItem(
        icon: Icons.home,
        label: 'Home',
        onTap: () {
          Get.to(() => const HomeMobile());
        },
      ),
      SidebarXItem(
        icon: Icons.favorite,
        label: 'Favorite',
        onTap: () {
          Get.to(() => const Favorite());
        },
      ),
      SidebarXItem(
        icon: Icons.bookmark_added,
        label: 'BookMark',
        onTap: () {
          Get.to(() => const BookMark());
        },
      ),
      SidebarXItem(
        icon: Icons.note_add,
        label: 'Notes',
        onTap: () {
          Get.to(() => const NotesView());
        },
      ),
      SidebarXItem(
        icon: Icons.settings,
        label: 'Settings',
        onTap: () {
          Get.to(() => const SettingsWithAppbar());
        },
      ),
      SidebarXItem(
        icon: Icons.privacy_tip,
        label: 'Privacy Policy',
        onTap: () {
          launchUrl(Uri.parse(
              "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"));
        },
      ),
    ],
  );
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
