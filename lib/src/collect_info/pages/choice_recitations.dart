// import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../api/all_recitation.dart';
import '../getx/get_controller.dart';

class RecitationChoice extends StatefulWidget {
  final Map<String, String>? previousInfo;
  const RecitationChoice({super.key, this.previousInfo});

  @override
  State<RecitationChoice> createState() => _RecitationChoiceState();
}

class _RecitationChoiceState extends State<RecitationChoice> {
  final infoController = Get.put(InfoController());

  late List<String> allRecitationSearch = [];

  @override
  void initState() {
    allRecitationSearch.addAll(allRecitation);
    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          playingIndex = -1;
        });
      }
    });
    if (widget.previousInfo != null) {
      Map<String, String> temInfo = widget.previousInfo!;
      int index = allRecitationSearch.indexOf(temInfo['recitation_ID'] ?? "");
      if (index != -1) {
        infoController.recitationIndex.value = index;
        infoController.recitationName.value = allRecitationSearch[index];
      }
    }
    super.initState();
  }

  void search(String s) {
    setState(() {
      allRecitationSearch = allRecitation.where((element) {
        return element.toLowerCase().contains(s.toLowerCase());
      }).toList();
    });
    select();
  }

  void select() {
    infoController.recitationIndex.value =
        allRecitationSearch.indexOf(infoController.recitationName.value);
    if (widget.previousInfo != null) {
      Map<String, String> temInfo = widget.previousInfo!;
      temInfo["recitation_ID"] = infoController.recitationName.value;
      final temInfoBox = Hive.box("info");
      temInfoBox.put("info", temInfo);
    }
  }

  List<String> listUrl = [];
  int playing = 0;

  void playResource(String url, int ayahCount) async {
    playing = 0;
    listUrl = [];
    setState(() {
      listUrl;
    });
    for (int i = 1; i <= 7; i++) {
      listUrl.add("$url/00100$i.mp3");
    }
    setState(() {
      listUrl;
    });

    List<AudioSource> audioResourceSource = [];
    for (int i = 0; i < 7; i++) {
      audioResourceSource.add(LockCachingAudioSource(
        Uri.parse(listUrl[i]),
        tag: MediaItem(
          displayTitle: "Surah Fateha",
          id: "$i",
          title: url,
        ),
      ));
    }
    final playlist = ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: audioResourceSource,
    );
    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      final connectivityResult = await Connectivity().checkConnectivity();

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) =>
            (connectivityResult.contains(ConnectivityResult.mobile) ||
                    connectivityResult.contains(ConnectivityResult.wifi) ||
                    connectivityResult.contains(ConnectivityResult.ethernet))
                ? AlertDialog(
                    title: const Text("Oops! Audio temporarily unavailable!"),
                    content: const Text(
                      "Thank you for using our app! It looks like the audio files are currently offline. We’re working hard to get everything back up and running smoothly. Please check back soon, and thank you for your patience and understanding!",
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  )
                : AlertDialog(
                    title: const Text("Oops! You have no internet connection"),
                    content: const Text(
                        "Note: When you play any ayah for the first time it will get downloaded from internet. Then it will stored as cached data in your local memory. You need internet connection now for play this audio."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  ),
      );
    }
  }

  void resumeOrPauseAudio(bool isPlay) {
    if (isPlay) {
      player.play();
    } else {
      player.pause();
    }
  }

  AudioPlayer player = AudioPlayer();

  String getBaseURLOfAudio(int value) {
    String recitor = allRecitationSearch[value];
    List<String> splited = recitor.split("(");
    String urlID = splited[1].replaceAll(")", "");
    String audioBaseURL = "https://everyayah.com/data/$urlID";
    return audioBaseURL;
  }

  int playingIndex = -1;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choice Recitation",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 5.0, right: 5, bottom: 2, top: 2),
            child: CupertinoSearchTextField(
              autofocus: false,
              onChanged: (value) => search(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 100, top: 10, left: 1, right: 1),
              itemCount: allRecitationSearch.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    int value = index;
                    infoController.recitationName.value =
                        allRecitationSearch[value];
                    select();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey.withOpacity(0.07),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 0,
                      titleAlignment: ListTileTitleAlignment.center,
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: IconButton(
                                  iconSize: 18,
                                  onPressed: () async {
                                    if (playingIndex != index) {
                                      setState(() {
                                        playingIndex = index;
                                        String url = getBaseURLOfAudio(index);
                                        playResource(url, 7);
                                      });
                                    } else {
                                      setState(() {
                                        playingIndex = -1;
                                      });
                                      resumeOrPauseAudio(false);
                                    }
                                  },
                                  icon: Icon(playingIndex == index
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(108, 0, 140, 255),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allRecitationSearch[index],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      leading: Obx(
                        () => Radio(
                          activeColor: Colors.green,
                          value: index,
                          groupValue: infoController.recitationIndex.value,
                          onChanged: (value) {
                            infoController.recitationName.value =
                                allRecitationSearch[value!];
                            select();
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
