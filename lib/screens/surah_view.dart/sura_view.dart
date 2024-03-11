import 'package:al_bayan_quran/screens/settings/settings.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/surah_with_translation.dart';
import 'package:al_bayan_quran/theme/theme_controller.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            surahName ?? "Al Bayan Quran",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
      body: SurahWithTranslation(
        surahNumber: surahNumber,
        start: start,
        end: end,
        surahName: surahName,
        scrollToAyah: scrollToAyah,
      ),
    );
  }
}
