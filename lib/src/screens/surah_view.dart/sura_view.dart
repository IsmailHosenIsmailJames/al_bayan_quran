import 'package:al_quran/src/screens/settings/settings.dart';
import 'package:al_quran/src/screens/surah_view.dart/surah_view_reading.dart';
import 'package:al_quran/src/screens/surah_view.dart/surah_with_translation.dart';
import 'package:al_quran/src/theme/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

class SuraView extends StatelessWidget {
  final int surahNumber;
  final String? surahName;
  final int? start;
  final int? end;
  final int? scrollToAyah;
  const SuraView(
      {super.key,
      required this.surahNumber,
      this.start,
      this.end,
      this.surahName,
      this.scrollToAyah});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              surahName ?? "Al Quran",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.book_24_regular,
                    ),
                    Gap(5),
                    Text(
                      'Translation',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.document_one_page_24_regular,
                    ),
                    Gap(5),
                    Text(
                      'Reading',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await Hive.openBox(quranScriptType);
                showModalBottomSheet(
                  // ignore: use_build_context_synchronously
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.90,
                      minChildSize: 0.25,
                      maxChildSize: 1,
                      builder: (context, scrollController) {
                        return const Settings(
                          showNavigator: true,
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
        ),
        body: TabBarView(
          children: [
            SurahWithTranslation(
              surahNumber: surahNumber,
              start: start,
              end: end,
              surahName: surahName,
              scrollToAyah: scrollToAyah,
            ),
            SurahViewReading(
              surahNumber: surahNumber,
              start: start,
              end: end,
              surahName: surahName,
              scrollToAyah: scrollToAyah,
            ),
          ],
        ),
      ),
    );
  }
}
