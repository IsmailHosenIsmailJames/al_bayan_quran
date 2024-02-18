import 'package:al_bayan_quran/screens/surah_view.dart/surah_with_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../getx_controller.dart';
import 'quran_reading_view.dart';

// import '../drawer/drawer.dart';

class SuraView extends StatelessWidget {
  final int surahNumber;
  final String? surahName;
  final int? start;
  final int? end;
  const SuraView(
      {super.key,
      required this.surahNumber,
      this.start,
      this.end,
      this.surahName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Center(
                child: Text(
                  surahName ?? "Al Bayan Quran",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Translation",
                  ),
                  Tab(
                    text: "Quran",
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    final fontSize = Get.put(ScreenGetxController());
                    final translation = Hive.box("translation");
                    final infoBox = Hive.box("info");
                    final info = infoBox.get("info", defaultValue: false);

                    String ayahTranslation =
                        translation.get("${info["translation_book_ID"]}/1");

                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.90,
                          minChildSize: 0.25,
                          maxChildSize: 1,
                          builder: (context, scrollController) {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () => Expanded(
                                        child: Slider(
                                            value:
                                                fontSize.fontSizeArabic.value,
                                            max: 50,
                                            min: 5,
                                            onChanged: (value) {
                                              final infoBox = Hive.box("info");
                                              infoBox.put("fontSizeArabic",
                                                  value.toPrecision(2));
                                              fontSize.fontSizeArabic.value =
                                                  value.toPrecision(2);
                                            }),
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        fontSize.fontSizeArabic.value
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          60, 120, 120, 120),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () => Expanded(
                                        child: Slider(
                                            value: fontSize
                                                .fontSizeTranslation.value,
                                            max: 50,
                                            min: 5,
                                            onChanged: (value) {
                                              final infoBox = Hive.box("info");
                                              infoBox.put("fontSizeTranslation",
                                                  value.toPrecision(2));
                                              fontSize.fontSizeTranslation
                                                  .value = value.toPrecision(2);
                                            }),
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        fontSize.fontSizeTranslation.value
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(60, 120, 120, 120),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Obx(
                                    () => Text(
                                      ayahTranslation,
                                      style: TextStyle(
                                        fontSize:
                                            fontSize.fontSizeTranslation.value,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                  ),
                )
              ],
            )
          ],
          body: TabBarView(
            children: [
              SurahWithTranslation(
                surahNumber: surahNumber,
                start: start,
                end: end,
                surahName: surahName,
              ),
              SurahWithReading(
                surahNumber: surahNumber,
                start: start,
                end: end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
