import 'package:al_bayan_quran/api/all_recitation.dart';
import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../api/some_api_response.dart';

class Audio extends StatefulWidget {
  const Audio({super.key});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();
  String currentReciter = "";
  int playingIndex = -1;
  int surahNumber = -1;

  List<DropdownMenuEntry<Object>> dropdownList = [];

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
        setState(() {
          playingIndex = -1;
        });
      }
    });

    super.initState();
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

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 5,
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownMenu(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  menuHeight: 300,
                  width: MediaQuery.of(context).size.width - 20,
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
              ],
            ),
          ),
          Expanded(
            child: ListView(children: listSurahProvider(114)),
          ),
          Text(currentReciter.split("(")[0]),
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(30, 125, 125, 125),
              borderRadius: BorderRadius.all(
                Radius.circular(100),
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
    );
  }

  void playAudio(int index, {bool start = false}) async {
    setState(() {
      surahNumber = index;
    });

    List<String> listOfURL = getAllAudioUrl();
    if (playingIndex != index || start) {
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

  List<Widget> listSurahProvider(length) {
    List<Widget> listSurah = [];

    for (int index = 0; index < length; index++) {
      String revelationPlace = allChaptersInfo[index]['revelation_place'];
      String nameSimple = allChaptersInfo[index]['name_simple'];
      String nameArabic = allChaptersInfo[index]['name_arabic'];
      int versesCount = allChaptersInfo[index]['verses_count'];
      listSurah.add(
        GestureDetector(
          onTap: () => playAudio(index),
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
}
