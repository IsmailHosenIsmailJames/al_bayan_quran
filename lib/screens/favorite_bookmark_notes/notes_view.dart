import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../api/some_api_response.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  int getAyahCountFromStart(int ayahNumber, int surahNumber) {
    for (int i = 0; i < surahNumber; i++) {
      int verseCount = allChaptersInfo[i]['verses_count'];
      ayahNumber += verseCount;
    }
    return ayahNumber;
  }

  List<Map<String, String>> getNotesData() {
    final notesBox = Hive.box("notes");
    final quranBox = Hive.box("quran");
    final translationBox = Hive.box("translation");
    List<Map<String, String>> notesMapList = [];
    final box = Hive.box("info");

    for (String key in notesBox.keys) {
      if (key.endsWith("note")) {
        String note = notesBox.get(key, defaultValue: null) ?? "";
        String title =
            notesBox.get(key.replaceAll("note", "title"), defaultValue: null) ??
                "";
        String ayahKey = key.replaceAll("note", "");
        String surahNumber = ayahKey.substring(0, 3);
        String ayahNumber = ayahKey.substring(3);
        String ayahCount = getAyahCountFromStart(
                int.parse(ayahNumber) - 1, int.parse(surahNumber) - 1)
            .toString();
        final info = box.get("info", defaultValue: false);

        String quranAyah = quranBox.get(ayahCount) ?? "";
        String transltionOfAyah =
            translationBox.get("${info["translation_book_ID"]}/$ayahCount") ??
                "";

        notesMapList.add({
          "key": ayahKey,
          "title": title,
          "note": note,
          "surahNumber": surahNumber,
          "ayahNumber": ayahNumber,
          "ayahCount": ayahCount,
          "quranAyah": quranAyah,
          "transltionOfAyah": transltionOfAyah
        });
      }
    }
    return notesMapList;
  }

  @override
  Widget build(BuildContext context) {
    getNotesData();
    return ListView();
  }
}
