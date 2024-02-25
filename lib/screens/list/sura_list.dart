import 'package:al_bayan_quran/api/some_api_response.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/sura_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

class SuraList extends StatefulWidget {
  const SuraList({super.key});

  @override
  State<SuraList> createState() => _SuraListState();
}

class _SuraListState extends State<SuraList> {
  final player = AudioPlayer();

//   void abc() async {
//     // Define the playlist
//     final playlist = ConcatenatingAudioSource(
//       // Start loading next item just before reaching it
//       useLazyPreparation: true,
//       // Customise the shuffle algorithm
//       shuffleOrder: DefaultShuffleOrder(),
//       // Specify the playlist items

//       children: [
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001001.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001002.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001003.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001004.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001005.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001006.mp3')),
//         LockCachingAudioSource(Uri.parse(
//             'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001007.mp3')),
//       ],
//     );

// // Load and play the playlist
//     await player.setAudioSource(playlist,
//         initialIndex: 0, initialPosition: Duration.zero);
//     await player.play();
//   }

//   @override
//   void initState() {
//     abc();
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      radius: const Radius.circular(10),
      thumbVisibility: true,
      thickness: 10,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 50),
        children: listSurahProvider(114),
      ),
    );
  }

  List<Widget> listSurahProvider(length) {
    List<Widget> listSurah = [];

    for (int index = 0; index < length; index++) {
      String revelationPlace = allChaptersInfo[index]['revelation_place'];
      String nameSimple = allChaptersInfo[index]['name_simple'];
      String nameArabic = allChaptersInfo[index]['name_arabic'];
      int versesCount = allChaptersInfo[index]['verses_count'];
      listSurah.add(
        GestureDetector(
          onTap: () async {
            await Hive.openBox("translation");
            await Hive.openBox("quran");
            Get.to(() {
              return SuraView(
                surahNumber: index,
                surahName: nameSimple,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(30, 125, 125, 125),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromARGB(195, 0, 133, 4),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameSimple,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            revelationPlace,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 136, 136, 136),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nameArabic,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "$versesCount Ayahs",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 136, 136, 136),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return listSurah;
  }
}
