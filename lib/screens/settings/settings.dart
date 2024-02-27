import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../getx_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final fontSize = Get.put(ScreenGetxController());
  final translation = Hive.box("translation");
  final infoBox = Hive.box("info");
  late final info = infoBox.get("info", defaultValue: false);

  late String ayahTranslation =
      translation.get("${info["translation_book_ID"]}/1");

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const Text("Font Size Of Quran"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Expanded(
                child: Slider(
                    value: fontSize.fontSizeArabic.value,
                    max: 50,
                    min: 5,
                    onChanged: (value) {
                      final infoBox = Hive.box("info");
                      infoBox.put("fontSizeArabic", value.toPrecision(2));
                      fontSize.fontSizeArabic.value = value.toPrecision(2);
                    }),
              ),
            ),
            Obx(
              () => Text(
                fontSize.fontSizeArabic.value.toString(),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(60, 120, 120, 120),
              borderRadius: BorderRadius.circular(10)),
          child: Obx(
            () => Text(
              "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
              style: TextStyle(
                fontSize: fontSize.fontSizeArabic.value,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text("Font Size Of Translation"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Expanded(
                child: Slider(
                    value: fontSize.fontSizeTranslation.value,
                    max: 50,
                    min: 5,
                    onChanged: (value) {
                      final infoBox = Hive.box("info");
                      infoBox.put("fontSizeTranslation", value.toPrecision(2));
                      fontSize.fontSizeTranslation.value = value.toPrecision(2);
                    }),
              ),
            ),
            Obx(
              () => Text(
                fontSize.fontSizeTranslation.value.toString(),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(60, 120, 120, 120),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => Text(
              ayahTranslation,
              style: TextStyle(
                fontSize: fontSize.fontSizeTranslation.value,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
