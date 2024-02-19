import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/all_recitation.dart';
import '../getx/get_controller.dart';

class RecitaionChoice extends StatefulWidget {
  const RecitaionChoice({super.key});

  @override
  State<RecitaionChoice> createState() => _RecitaionChoiceState();
}

class _RecitaionChoiceState extends State<RecitaionChoice> {
  final infoController = Get.put(InfoController());
  final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late List<String> allRecitationSearch = [];

  @override
  void initState() {
    allRecitationSearch.addAll(allRecitation);
    player.onPlayerComplete.listen((state) {
      if (playing >= 6) {
        setState(() {
          playingIndex = -1;
        });
      } else {
        playing++;
        player.play(UrlSource(listUrl[playing]));
      }
    });
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

    player.play(UrlSource(listUrl[0]));
  }

  void resumeOrPuseAudio(bool isPlay) {
    if (isPlay) {
      player.resume();
    } else {
      player.pause();
    }
  }

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
                const EdgeInsets.only(left: 5.0, right: 5, bottom: 5, top: 5),
            child: TextFormField(
              autofocus: true,
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
                  bottom: 100, top: 10, left: 3, right: 3),
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
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index % 2 == 0
                            ? const Color.fromARGB(30, 131, 240, 255)
                            : const Color.fromARGB(30, 139, 255, 128)),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: IconButton(
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