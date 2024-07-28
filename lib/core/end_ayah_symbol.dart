import 'package:flutter/material.dart';

Map<String, String> mapOfAyahSymbol = {
  "0": '\u0660',
  "1": '\u0661',
  "2": '\u0662',
  "3": '\u0663',
  "4": '\u0664',
  "5": '\u0665',
  "6": '\u0666',
  "7": '\u0667',
  "8": '\u0668',
  "9": '\u0669',
};
String getEndSyambolOfAyah(String ayahNumber) {
  String endSyambolOfAyah = "\u06DD";
  List<String> tem = ayahNumber.characters.toList();
  for (String c in tem) {
    endSyambolOfAyah += mapOfAyahSymbol[c] ?? "";
  }
  return endSyambolOfAyah;
}
