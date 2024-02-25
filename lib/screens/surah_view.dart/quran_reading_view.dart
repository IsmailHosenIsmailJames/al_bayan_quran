import 'package:al_bayan_quran/api/some_api_response.dart';
import 'package:al_bayan_quran/screens/getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

class SurahWithReading extends StatefulWidget {
  final int surahNumber;
  final int? start;
  final int? end;
  const SurahWithReading(
      {super.key, required this.surahNumber, this.start, this.end});

  @override
  State<SurahWithReading> createState() => _SurahWithReadingState();
}

class _SurahWithReadingState extends State<SurahWithReading> {
  late int totalAyahInSuarh;
  late String? surahNameSimple;
  late String? surahNameArabic;
  late String? relavencePlace;
  final player = AudioPlayer();

  List<int> listOfAyah = [];
  List<GlobalKey> listOfkey = [];

  @override
  void initState() {
    totalAyahInSuarh = allChaptersInfo[widget.surahNumber]['verses_count'];
    surahNameSimple = allChaptersInfo[widget.surahNumber]['name_simple'];
    surahNameArabic = allChaptersInfo[widget.surahNumber]['name_arabic'];
    relavencePlace = allChaptersInfo[widget.surahNumber]['revelation_place'];
    int start = widget.start ?? 0;
    int end = widget.end ?? allChaptersInfo[widget.surahNumber]['verses_count'];
    for (int i = start; i < end; i++) {
      listOfAyah.add(i);
      listOfkey.add(GlobalKey());
    }
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  final controller = Get.put(ScreenGetxController());
  final ScrollController scrollController = ScrollController();
  bool isPlaying = false;
  int playingIndex = -1;

  int getAyahCountFromStart(int ayahNumber) {
    for (int i = 0; i < widget.surahNumber; i++) {
      int verseCount = allChaptersInfo[i]['verses_count'];
      ayahNumber += verseCount;
    }
    return ayahNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      controller: scrollController,
      radius: const Radius.circular(10),
      thumbVisibility: true,
      thickness: 10,
      child: ListView(
        controller: scrollController,
        children: listOfWidgetOfAyah(listOfAyah.length + 1),
      ),
    );
  }

  List<Widget> listOfWidgetOfAyah(int length) {
    List<Widget> listAyahWidget = [];

    int firstAyahNumber = getAyahCountFromStart(0);

    for (int index = 0; index < length - 1; index++) {
      {
        final quran = Hive.box('quran');
        int ayahNumber = listOfAyah[index];
        String arbicAyah = quran.get("${ayahNumber + firstAyahNumber}");

        listAyahWidget.add(
          Container(
            key: listOfkey[index],
            padding: const EdgeInsets.all(10),
            child: Obx(
              () => Text(
                arbicAyah,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: controller.fontSizeArabic.value,
                ),
              ),
            ),
          ),
        );
      }
    }
    return listAyahWidget;
  }
}
