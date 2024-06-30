// import 'package:audioplayers/audioplayers.dart';
import 'package:al_bayan_quran/core/audio/audio_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

import '../../api/all_recitation.dart';
import '../getx/get_controller.dart';

class RecitaionChoice extends StatefulWidget {
  final Map<String, String>? previousInfo;
  const RecitaionChoice({super.key, this.previousInfo});

  @override
  State<RecitaionChoice> createState() => _RecitaionChoiceState();
}

class _RecitaionChoiceState extends State<RecitaionChoice> {
  final infoController = Get.put(InfoController());
  int currentAyahIndex = 0;
  late List<String> allRecitationSearch = [];

  int cheakIsFinished = 0;
  int ayahIndex = 0;
  @override
  void initState() {
    allRecitationSearch.addAll(allRecitation);

    player.playbackEventStream.listen(
      (event) {
        int dif = event.updatePosition.compareTo(Duration.zero);
        if (dif == 0 && cheakIsFinished != 0) {
          ayahIndex++;
          playIndexFormCache(ayahIndex);
        }
        cheakIsFinished = dif;
      },
    );
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

  Future<void> playIndexFormCache(int i) async {
    if (i >= listUrl.length) return;

    String url = listUrl[i];
    String? path = await getAudioCachedPath(url);
    if (path == null) {
      showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const Center(
          child: Text(
            "Failed while downloading audio",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      );
      return;
    }
    await player.setFilePath(path);
    await player.play();
    i++;
    if (i >= listUrl.length) return;
    //just download
    await getAudioCachedPath(listUrl[i]);
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

  void setPlayResourceURLList(String url, int ayahCount) async {
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

    playIndexFormCache(0);
  }

  void resumeOrPuseAudio(bool isPlay) {
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 5.0, right: 5, bottom: 2, top: 2),
            child: TextFormField(
              autofocus: false,
              onChanged: (value) => search(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.07),
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                onPressed: () async {
                                  if (playingIndex != index) {
                                    setState(() {
                                      playingIndex = index;
                                      String url = getBaseURLOfAudio(index);
                                      setPlayResourceURLList(url, 7);
                                    });
                                  } else {
                                    setState(() {
                                      playingIndex = -1;
                                    });
                                    resumeOrPuseAudio(false);
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allRecitationSearch[index],
                                  style: const TextStyle(fontSize: 18),
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
