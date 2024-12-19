// import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

import 'package:al_quran/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran/src/core/audio/play_quran_audio.dart';
import 'package:al_quran/src/core/recitation_info/recitation_info_model.dart';
import 'package:al_quran/src/core/recitation_info/recitations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../getx/get_controller.dart';

class RecitationChoice extends StatefulWidget {
  final Map<String, String>? previousInfo;
  const RecitationChoice({super.key, this.previousInfo});

  @override
  State<RecitationChoice> createState() => _RecitationChoiceState();
}

class _RecitationChoiceState extends State<RecitationChoice> {
  final infoController = Get.put(InfoController());
  late List<RecitationInfoModel> allRecitationSearch = [];

  @override
  void initState() {
    for (var element in recitationsInfoList) {
      allRecitationSearch.add(RecitationInfoModel.fromMap(element));
    }
    super.initState();
  }

  void select(int index) {
    infoController.recitationIndex.value = allRecitationSearch[index];
  }

  void searchOnList(String text) {
    List<RecitationInfoModel> matched = [];
    for (var element in recitationsInfoList) {
      final tem = RecitationInfoModel.fromMap(element);
      if (tem.name?.toLowerCase().contains(text) == true ||
          tem.subfolder?.toLowerCase().contains(text) == true) {
        matched.add(RecitationInfoModel.fromMap(element));
      }
    }
    log(text);
    log(matched.length.toString());
    setState(() {
      allRecitationSearch = matched;
    });
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
              style: Theme.of(context).textTheme.bodyMedium,
              autofocus: false,
              onChanged: (value) {
                searchOnList(value.toLowerCase());
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 100, top: 10, left: 1, right: 1),
              itemCount: allRecitationSearch.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 5, top: 5),
                      backgroundColor: Colors.green.shade400.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: () {
                      select(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Obx(
                        () => Stack(
                          children: [
                            Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: GetX<AudioController>(
                                      builder: (controller) => IconButton(
                                        iconSize: 18,
                                        onPressed: () async {
                                          controller.currentRecitation.value =
                                              allRecitationSearch[index];
                                          await Hive.box('info').put(
                                              'reciter',
                                              allRecitationSearch[index]
                                                  .toJson());
                                          ManageQuranAudio
                                              .playMultipleAyahOfSurah(
                                            surahNumber: 1,
                                          );
                                        },
                                        icon: Icon(
                                          (controller.isPlaying.value &&
                                                  controller.currentRecitation
                                                          .value.subfolder ==
                                                      allRecitationSearch[index]
                                                          .subfolder)
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                        style: IconButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.blue.shade800,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        allRecitationSearch[index].name ?? "",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (infoController
                                    .recitationIndex.value.subfolder ==
                                allRecitationSearch[index].subfolder)
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
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
