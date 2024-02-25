// import 'dart:convert';

// import 'package:al_bayan_quran/api/some_api_response.dart';
// import 'package:al_bayan_quran/screens/getx_controller.dart';
// import 'package:al_bayan_quran/screens/surah_view.dart/tafseer/tafseer.dart';
// import 'package:archive/archive.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// import 'notes/notes.dart';

// class SurahWithTranslationJustAudio extends StatefulWidget {
//   final int surahNumber;
//   final int? start;
//   final int? end;
//   final String? surahName;
//   const SurahWithTranslationJustAudio(
//       {super.key,
//       required this.surahNumber,
//       this.start,
//       this.end,
//       required this.surahName});

//   @override
//   State<SurahWithTranslationJustAudio> createState() =>
//       _SurahWithTranslationJustAudioState();
// }

// class _SurahWithTranslationJustAudioState
//     extends State<SurahWithTranslationJustAudio> {
//   late int totalAyahInSuarh;
//   late String? surahNameSimple;
//   late String? surahNameArabic;
//   late String? relavencePlace;
//   final player = AudioPlayer();

//   List<int> listOfAyah = [];
//   List<GlobalKey> listOfkey = [];
//   List<String> listOfAudioURL = [];

//   @override
//   void initState() {
//     totalAyahInSuarh = allChaptersInfo[widget.surahNumber]['verses_count'];
//     surahNameSimple = allChaptersInfo[widget.surahNumber]['name_simple'];
//     surahNameArabic = allChaptersInfo[widget.surahNumber]['name_arabic'];
//     relavencePlace = allChaptersInfo[widget.surahNumber]['revelation_place'];
//     int start = widget.start ?? 0;
//     int end = widget.end ?? allChaptersInfo[widget.surahNumber]['verses_count'];
//     for (int i = start; i < end; i++) {
//       listOfAyah.add(i);
//       listOfkey.add(GlobalKey());
//       listOfAudioURL.add(getFullURL(i + 1));
//     }

//     player.onPlayerStateChanged.listen((event) {
//       if (event == PlayerState.playing) {
//         setState(() {
//           isPlaying = true;
//           showFloatingControllers = true;
//         });
//       } else {
//         setState(() {
//           isPlaying = false;
//         });
//       }
//     });

//     player.onPlayerComplete.listen((event) async {
//       if (toContinue) {
//         setState(() {
//           playingIndex++;
//         });
//         if (playingIndex >= totalAyahInSuarh) {
//           setState(() {
//             isPlaying = false;
//             showFloatingControllers = false;
//           });
//         } else {
//           await player.play(UrlSource(listOfAudioURL[playingIndex]));
//           if (listOfkey[playingIndex].currentContext != null) {
//             Scrollable.ensureVisible(
//               listOfkey[playingIndex].currentContext!,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.ease,
//             );
//           }
//           setState(() {
//             showFloatingControllers = true;
//           });
//         }
//       } else {
//         setState(() {
//           showFloatingControllers = false;
//         });
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//   }

//   final controller = Get.put(ScreenGetxController());
//   final ScrollController scrollController = ScrollController();
//   bool isPlaying = false;
//   int playingIndex = -1;
//   bool toContinue = false;
//   int currentPlayingIndex = -1;
//   bool showFloatingControllers = false;
//   bool expandFloatingControllers = true;

//   String getBaseURLOfAudio(String recitor) {
//     List<String> splited = recitor.split("(");
//     String urlID = splited[1].replaceAll(")", "");
//     String audioBaseURL = "https://everyayah.com/data/$urlID";
//     return audioBaseURL;
//   }

//   String getIdOfAudio(int ayahNumber) {
//     String suraString = "";
//     if (widget.surahNumber < 10) {
//       suraString = "00${widget.surahNumber + 1}";
//     } else if (widget.surahNumber + 1 < 100) {
//       suraString = "0${widget.surahNumber + 1}";
//     } else {
//       suraString = (widget.surahNumber + 1).toString();
//     }
//     String ayahString = "";

//     if (ayahNumber < 10) {
//       ayahString = "00$ayahNumber";
//     } else if (ayahNumber < 100) {
//       ayahString = "0$ayahNumber";
//     } else {
//       ayahString = ayahNumber.toString();
//     }
//     return suraString + ayahString;
//   }

//   int getAyahCountFromStart(int ayahNumber) {
//     for (int i = 0; i < widget.surahNumber; i++) {
//       int verseCount = allChaptersInfo[i]['verses_count'];
//       ayahNumber += verseCount;
//     }
//     return ayahNumber;
//   }

//   String getFullURL(int ayahNumber) {
//     final infoBox = Hive.box("info");
//     final info = infoBox.get("info");
//     String recitorChoice = info['recitation_ID'];
//     String baseURL = getBaseURLOfAudio(recitorChoice);
//     String audioID = getIdOfAudio(ayahNumber);
//     return "$baseURL/$audioID.mp3";
//   }

//   void showInfomationOfSurah() async {
//     final quranInfoBox = await Hive.openBox("quran_info");
//     final infoBox = Hive.box("info");
//     final info = infoBox.get("info", defaultValue: false);

//     final quranInformation = quranInfoBox.get(
//         "info_${info["translation_book_ID"]}/${widget.surahNumber + 1}/text",
//         defaultValue: false);
//     String text = "";
//     String shortText = "";
//     String source = "";

//     if (quranInformation != false) {
//       GZipDecoder decoder = GZipDecoder();
//       text = utf8
//           .decode(decoder.decodeBytes(base64Decode(quranInformation["text"])));
//       shortText = quranInformation['short_text'];
//       source = quranInformation['source'];
//     }
//     showModalBottomSheet(
//       // ignore: use_build_context_synchronously
//       context: context,
//       useSafeArea: true,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.90,
//           minChildSize: 0.25,
//           maxChildSize: 1,
//           builder: (context, scrollController) {
//             return ListView(
//               padding: const EdgeInsets.all(10),
//               children: [
//                 Row(
//                   children: [
//                     const Spacer(),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const Text(
//                   "Source",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   source,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 3,
//                 ),
//                 const Text(
//                   "Summary",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   shortText,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const Divider(
//                   thickness: 3,
//                 ),
//                 const Text(
//                   "In Detail",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 HtmlWidget(text),
//                 const SizedBox(
//                   height: 50,
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       isScrollControlled: true,
//     );
//   }

//   Future<String> showTafseerOfAyah(
//       int ayahNumber, String? surahName, bool goRoute) async {
//     final tafseerBox = await Hive.openBox("tafseer");
//     int ayahCountFromStart = getAyahCountFromStart(ayahNumber - 1);
//     final infoBox = Hive.box("info");
//     final info = infoBox.get("info", defaultValue: false);

//     final tafseer =
//         tafseerBox.get("${info['tafseer_book_ID']}/$ayahCountFromStart");
//     GZipDecoder decoder = GZipDecoder();
//     String decodedTafseer =
//         utf8.decode(decoder.decodeBytes(base64Decode(tafseer)));

//     if (goRoute) {
//       Get.to(() => TafseerVoiceLess(
//             surahName: surahName,
//             ayahNumber: ayahNumber,
//             surahNumber: widget.surahNumber,
//             tafseer: decodedTafseer,
//           ));
//     }
//     return decodedTafseer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: showFloatingControllers
//           ? FloatingActionButton.extended(
//               onPressed: null,
//               label: expandFloatingControllers
//                   ? Row(
//                       children: [
//                         IconButton(
//                           onPressed: playingIndex > 0
//                               ? () async {
//                                   setState(() {
//                                     playingIndex--;
//                                   });
//                                   await player.play(
//                                       UrlSource(listOfAudioURL[playingIndex]));
//                                   if (listOfkey[playingIndex].currentContext !=
//                                       null) {
//                                     Scrollable.ensureVisible(
//                                       listOfkey[playingIndex].currentContext!,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       curve: Curves.ease,
//                                     );
//                                   }
//                                   setState(() {
//                                     showFloatingControllers = true;
//                                   });
//                                 }
//                               : null,
//                           icon: const Icon(
//                             Icons.skip_previous,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         IconButton(
//                           color: Colors.white,
//                           onPressed: () {
//                             if (isPlaying) {
//                               player.pause();
//                             } else {
//                               player.resume();
//                             }
//                           },
//                           style: const ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                               Colors.green,
//                             ),
//                           ),
//                           icon: isPlaying
//                               ? const Icon(Icons.pause)
//                               : const Icon(Icons.play_arrow),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         IconButton(
//                           onPressed: playingIndex < totalAyahInSuarh - 1
//                               ? () async {
//                                   setState(() {
//                                     playingIndex++;
//                                   });
//                                   await player.play(
//                                       UrlSource(listOfAudioURL[playingIndex]));
//                                   if (listOfkey[playingIndex].currentContext !=
//                                       null) {
//                                     Scrollable.ensureVisible(
//                                       listOfkey[playingIndex].currentContext!,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       curve: Curves.ease,
//                                     );
//                                   }
//                                   setState(() {
//                                     showFloatingControllers = true;
//                                   });
//                                 }
//                               : null,
//                           icon: const Icon(
//                             Icons.skip_next,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         // IconButton(
//                         //   onPressed: () {
//                         //     setState(() {
//                         //       toContinue = !toContinue;
//                         //     });
//                         //   },
//                         //   icon: toContinue
//                         //       ? const Icon(FontAwesomeIcons.lock)
//                         //       : const Icon(FontAwesomeIcons.unlock),
//                         // ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             if (isPlaying) {
//                               setState(() {
//                                 expandFloatingControllers = false;
//                               });
//                             } else {
//                               player.release();
//                               setState(() {
//                                 showFloatingControllers = false;
//                               });
//                             }
//                           },
//                           icon: const Icon(
//                             Icons.close,
//                           ),
//                         ),
//                       ],
//                     )
//                   : IconButton(
//                       onPressed: () {
//                         setState(() {
//                           expandFloatingControllers = true;
//                         });
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                       ),
//                     ),
//               extendedPadding: const EdgeInsets.all(5),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(100),
//                 ),
//               ),
//             )
//           : null,
//       body: Scrollbar(
//         interactive: true,
//         controller: scrollController,
//         radius: const Radius.circular(10),
//         thumbVisibility: true,
//         thickness: 10,
//         child: ListView(
//           controller: scrollController,
//           children: listOfWidgetOfAyah(listOfAyah.length + 1),
//         ),
//       ),
//     );
//   }

//   List<Widget> listOfWidgetOfAyah(int length) {
//     List<Widget> listAyahWidget = [];

//     int firstAyahNumber = getAyahCountFromStart(0);

//     for (int index = 0; index < length; index++) {
//       {
//         if (index == 0) {
//           String relevancePlace =
//               allChaptersInfo[widget.surahNumber]['revelation_place'];
//           int ayahNumber = allChaptersInfo[widget.surahNumber]['verses_count'];
//           listAyahWidget.add(Container(
//             margin: const EdgeInsets.all(8),
//             padding: const EdgeInsets.all(10),
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(60, 120, 120, 120),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: Container(
//                     height: 150,
//                     width: 150,
//                     margin: const EdgeInsets.only(right: 10),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(relevancePlace == 'makkah'
//                             ? "assets/img/makkah.jpg"
//                             : "assets/img/madina.jpeg"),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Revelation Place",
//                       style: TextStyle(
//                         fontSize: 12,
//                       ),
//                     ),
//                     Text(
//                       relavencePlace![0].toUpperCase() +
//                           relevancePlace.substring(1),
//                       style: const TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "$ayahNumber Ayahs",
//                       style: const TextStyle(
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: showInfomationOfSurah,
//                           style: const ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                               Colors.green,
//                             ),
//                           ),
//                           icon: const Icon(
//                             Icons.info_outline_rounded,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         IconButton(
//                           iconSize: 30,
//                           style: const ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                               Colors.green,
//                             ),
//                           ),
//                           color: Colors.white,
//                           onPressed: () {
//                             setState(() {
//                               toContinue = true;
//                             });
//                             if (isPlaying) {
//                               currentPlayingIndex = playingIndex;
//                               player.pause();
//                             } else {
//                               if (currentPlayingIndex != -1) {
//                                 player.resume();
//                               } else {
//                                 setState(() {
//                                   playingIndex = 0;
//                                 });
//                                 player.play(UrlSource(listOfAudioURL[0]));
//                               }
//                             }
//                           },
//                           icon: isPlaying
//                               ? const Icon(Icons.pause)
//                               : const Icon(Icons.play_arrow),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ));
//         } else {
//           final translation = Hive.box("translation");
//           final quran = Hive.box('quran');
//           int ayahNumber = listOfAyah[index - 1];
//           final infoBox = Hive.box("info");
//           final info = infoBox.get("info", defaultValue: false);

//           String arbicAyah = quran.get("${ayahNumber + firstAyahNumber}");
//           String ayahTranslation = translation.get(
//               "${info["translation_book_ID"]}/${firstAyahNumber + listOfAyah[index - 1]}");
//           String bookName = "";
//           for (var element in allTranslationLanguage) {
//             if (element['id'].toString() == info['translation_book_ID']) {
//               bookName = element['name'];
//             }
//           }
//           listAyahWidget.add(
//             Container(
//               key: listOfkey[index - 1],
//               margin: const EdgeInsets.all(8),
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(60, 120, 120, 120),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.green,
//                         child: Text(
//                           (listOfAyah[index - 1] + 1).toString(),
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       PopupMenuButton(
//                         onSelected: (value) async {
//                           if (value == "copy" || value == "copyWithTafseer") {
//                             String allToCopy =
//                                 "${widget.surahName} ( ${widget.surahNumber + 1} : ${ayahNumber + 1} )\n\n$arbicAyah\n\n$ayahTranslation";

//                             if (value == "copy") {
//                               FlutterClipboard.copy(allToCopy);
//                             }

//                             allToCopy +=
//                                 "\n\n${await showTafseerOfAyah(index, surahNameArabic, false)}";
//                             FlutterClipboard.copy(allToCopy);
//                           }
//                           if (value == 'note') {
//                             await Hive.openBox("notes");
//                             Get.to(() => Notes(
//                                   surahNumber: widget.surahNumber,
//                                   ayahNumber: ayahNumber,
//                                   surahName: widget.surahName,
//                                 ));
//                           }
//                         },
//                         icon: const Icon(
//                           Icons.more_horiz,
//                         ),
//                         itemBuilder: (BuildContext bc) {
//                           return const [
//                             PopupMenuItem(
//                               value: 'note',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.note_add),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text("Notes"),
//                                 ],
//                               ),
//                             ),
//                             // PopupMenuItem(
//                             //   value: 'bookmark',
//                             //   child: Row(
//                             //     children: [
//                             //       Icon(Icons.star),
//                             //       SizedBox(
//                             //         width: 10,
//                             //       ),
//                             //       Text("Book Mark"),
//                             //     ],
//                             //   ),
//                             // ),
//                             PopupMenuItem(
//                               value: 'copy',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.copy),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text("Copy"),
//                                 ],
//                               ),
//                             ),
//                             PopupMenuItem(
//                               value: 'copyWithTafseer',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.copy),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text("Copy With Tafsser"),
//                                 ],
//                               ),
//                             ),
//                           ];
//                         },
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       IconButton(
//                         iconSize: 30,
//                         color: Colors.green,
//                         style: const ButtonStyle(
//                           backgroundColor: MaterialStatePropertyAll(
//                             Color.fromARGB(60, 150, 150, 150),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (index != playingIndex + 1) {
//                             player.play(UrlSource(listOfAudioURL[index - 1]));
//                             setState(() {
//                               playingIndex = index - 1;
//                             });
//                           }
//                           if (isPlaying) {
//                             player.pause();
//                           } else {
//                             setState(() {
//                               showFloatingControllers = true;
//                             });
//                             if (toContinue) {
//                               player.resume();
//                             } else {
//                               player.play(UrlSource(listOfAudioURL[index - 1]));
//                               setState(() {
//                                 playingIndex = index - 1;
//                                 toContinue = false;
//                               });
//                             }
//                           }
//                         },
//                         icon: index == playingIndex + 1 && isPlaying
//                             ? const Icon(Icons.pause)
//                             : const Icon(Icons.play_arrow),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTap: () {
//                       showTafseerOfAyah(index, surahNameArabic, true);
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           alignment: Alignment.topRight,
//                           child: Obx(
//                             () => Text(
//                               arbicAyah,
//                               textAlign: TextAlign.end,
//                               style: TextStyle(
//                                 fontSize: controller.fontSizeArabic.value,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Translation : $bookName",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Obx(
//                           () => Text(
//                             ayahTranslation,
//                             style: TextStyle(
//                               fontSize: controller.fontSizeTranslation.value,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//     }
//     return listAyahWidget;
//   }
// }
