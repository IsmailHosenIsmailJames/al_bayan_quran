import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../api/colors_tazweed.dart';
import '../../api/some_api_response.dart';
import '../../core/end_ayah_symbol.dart';
import '../favorite_bookmark_notes/get_data.dart';
import '../getx_controller.dart';
import '../settings/settings.dart';

class SurahViewReading extends StatefulWidget {
  final int surahNumber;
  final int? start;
  final int? end;
  final String? surahName;
  final int? scrollToAyah;
  const SurahViewReading({
    super.key,
    required this.surahNumber,
    this.start,
    this.end,
    required this.surahName,
    this.scrollToAyah,
  });

  @override
  State<SurahViewReading> createState() => _SurahViewReadingState();
}

class _SurahViewReadingState extends State<SurahViewReading> {
  late int totalAyahInSuarh;
  late String? surahNameSimple;
  late String? surahNameArabic;
  late String? relavencePlace;

  List<int> listOfAyah = [];
  List<GlobalKey> listOfkey = [];
  List<String> bookmarkSurahKey = [];
  List<String> favoriteSurahKey = [];

  final controller = Get.put(ScreenGetxController());

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

    final box = Hive.box("info");
    final bookmark = box.get("bookmark", defaultValue: false);
    if (bookmark != false) {
      bookmarkSurahKey = bookmark;
    }
    super.initState();
  }

  String startAyahBismillah(String scriptType) {
    final scriptBox = Hive.box(scriptType);
    return scriptBox.get("0", defaultValue: "0");
  }

  Future<dynamic> getAllAyahFormBox(String scriptType) async {
    String allAyah = "";
    List<String> listOfAyahScript = [];
    final scriptBox = Hive.box(scriptType);

    for (int i in listOfAyah) {
      int ayahNumber = i + getAyahCountFromStart(0, widget.surahNumber);
      String ayah = scriptBox.get("$ayahNumber", defaultValue: "0");
      if (scriptType == "quran_tajweed") {
        allAyah += ayah;
      } else {
        listOfAyahScript.add(ayah);
      }
    }
    return scriptType == "quran_tajweed" ? allAyah : listOfAyahScript;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ScreenGetxController>(
        builder: (controller) {
          return FutureBuilder(
            future: getAllAyahFormBox(controller.quranScriptTypeGetx.value),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.runtimeType == String) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Gap(15),
                          if (widget.surahNumber != 0)
                            getTazweedTexSpan(
                              startAyahBismillah(
                                controller.quranScriptTypeGetx.value,
                              ),
                              hideEnd: true,
                              doBold: true,
                            ),
                          const Gap(15),
                          getTazweedTexSpan(snapshot.data!),
                        ],
                      ),
                    ),
                  );
                } else {
                  List<String> listOfAyahScript =
                      List<String>.from(snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Gap(15),
                          if (widget.surahNumber != 0)
                            Text(
                              startAyahBismillah(
                                controller.quranScriptTypeGetx.value,
                              ),
                              style: TextStyle(
                                fontSize: controller.fontSizeArabic.value + 4,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const Gap(15),
                          Text.rich(
                            TextSpan(
                              children: List<InlineSpan>.generate(
                                listOfAyahScript.length,
                                (index) {
                                  return TextSpan(
                                    text:
                                        "${listOfAyahScript[index]} ${getEndSyambolOfAyah(index.toString())} ",
                                    style: TextStyle(
                                      fontSize: controller.fontSizeArabic.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.green,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildArabicText(String styleType, String ayahKey, int ayahNumber) {
    final box = Hive.box(styleType);
    if (styleType == "quran_tajweed") {
      return getTazweedTexSpan(
        box.get(ayahKey, defaultValue: ""),
      );
    }
    return Obx(
      () {
        return Text(
          box.get(ayahKey, defaultValue: ""),
          style: TextStyle(
            fontSize: controller.fontSizeArabic.value,
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }

  Widget getTazweedTexSpan(String ayah,
      {bool hideEnd = false, bool doBold = false}) {
    List<Map<String, String?>> tazweeds = extractWordsGetTazweeds(ayah);
    List<InlineSpan> spanText = [];
    for (int i = 0; i < tazweeds.length; i++) {
      Map<String, String?> taz = tazweeds[i];
      String word = taz['word'] ?? "";
      String className = taz['class'] ?? "null";
      String tag = taz['tag'] ?? "null";
      if (className == 'null' || tag == "null") {
        spanText.add(
          TextSpan(text: word),
        );
      } else {
        if (className == "end" && hideEnd != true) {
          spanText.add(
            TextSpan(
              text: "۝$word ",
            ),
          );
        } else {
          if (hideEnd && word.length == 1 && i == 13) {
            continue;
          }
          Color textColor = colorsForTazweed[className] ??
              const Color.fromARGB(255, 121, 85, 72);
          spanText.add(
            TextSpan(
              text: word,
              style: TextStyle(
                color: textColor,
              ),
            ),
          );
        }
      }
    }
    return Obx(
      () => Text.rich(
        textAlign: TextAlign.end,
        style: doBold
            ? const TextStyle(
                fontWeight: FontWeight.bold,
              )
            : null,
        TextSpan(
          style: TextStyle(
            fontSize: controller.fontSizeArabic.value,
          ),
          children: spanText,
        ),
      ),
    );
  }
}
