import 'dart:convert';

import 'package:al_quran/src/api/some_api_response.dart';
import 'package:al_quran/src/core/show_twoested_message.dart';
import 'package:al_quran/src/screens/getx_controller.dart';
import 'package:al_quran/src/screens/surah_view.dart/surah_view_reading.dart';
import 'package:al_quran/src/screens/surah_view.dart/tafseer/tafseer.dart';
import 'package:archive/archive.dart';
import 'package:clipboard/clipboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../api/colors_tazweed.dart';
import '../settings/settings.dart';
import 'notes/notes.dart';

class SurahWithTranslation extends StatefulWidget {
  final int surahNumber;
  final int? start;
  final int? end;
  final String? surahName;
  final int? scrollToAyah;
  const SurahWithTranslation({
    super.key,
    required this.surahNumber,
    this.start,
    this.end,
    required this.surahName,
    this.scrollToAyah,
  });

  @override
  State<SurahWithTranslation> createState() => _SurahWithTranslationState();
}

class _SurahWithTranslationState extends State<SurahWithTranslation> {
  late int totalAyahInSuarh;
  late String? surahNameSimple;
  late String? surahNameArabic;
  late String? relavencePlace;
  AudioPlayer player = AudioPlayer();

  List<int> listOfAyah = [];
  List<GlobalKey> listOfkey = [];
  List<String> bookmarkSurahKey = [];
  List<String> favoriteSurahKey = [];

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

    final favo = box.get("favorite", defaultValue: false);
    if (favo != false) {
      favoriteSurahKey = favo;
    }

    player.currentIndexStream.listen((event) {
      if (player.playing && event != null) {
        setState(() {
          playingIndex = event;
        });
        if (listOfkey[playingIndex].currentContext != null &&
            player.playing &&
            playingIndex > -1) {
          Scrollable.ensureVisible(
            listOfkey[playingIndex].currentContext!,
            duration: const Duration(milliseconds: 500),
            alignment: 0.5,
            curve: Curves.ease,
          );
        }
      }
      if (event != null) {
        setState(() {
          playingIndex = event;
        });
      }
    });

    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed &&
          playingIndex >= end - 1) {
        setState(() {
          showFloatingControllers = false;
          isLoading = false;
          isPlaying = false;
        });
      } else if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          showFloatingControllers = false;
          playingIndex = -1;
        });
      } else if (event.processingState == ProcessingState.loading) {
        setState(() {
          isLoading = true;
          showFloatingControllers = true;
        });
      } else if (event.playing) {
        setState(() {
          isPlaying = true;
          isLoading = false;
          showFloatingControllers = true;
        });
      } else if (event.playing == false) {
        setState(() {
          isPlaying = false;
          isLoading = false;
        });
      }
    });
    if (widget.scrollToAyah != null) scrollToAyahInit(widget.scrollToAyah!);
    super.initState();
  }

  void scrollToAyahInit(int ayah) async {
    for (int i = 1; i < ayah; i++) {
      await Future.delayed(const Duration(milliseconds: 5));

      if (listOfkey[i].currentContext != null) {
        await Scrollable.ensureVisible(
          listOfkey[i].currentContext!,
          alignment: 0.5,
        );
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  final controller = Get.put(ScreenGetxController());
  final ScrollController scrollController = ScrollController();
  bool isPlaying = false;
  int playingIndex = -1;
  bool isLoading = false;
  bool showFloatingControllers = false;
  bool expandFloatingControllers = true;
  void playAudioList(List<String> listOfAudioURL, int index,
      [bool dontPlayNow = false]) async {
    try {
      final infoBox = Hive.box("info");
      final info = infoBox.get("info");
      String recitorChoice = info['recitation_ID'];
      List<AudioSource> audioResourceSource = [];
      for (int i = 0; i < listOfAudioURL.length; i++) {
        audioResourceSource.add(
          LockCachingAudioSource(
            Uri.parse(listOfAudioURL[i]),
            tag: MediaItem(
              displayTitle: "$surahNameSimple - ${i + 1}",
              displaySubtitle: recitorChoice.split("(")[0],
              id: "$i",
              title: recitorChoice.split('(')[0],
              displayDescription: listOfAudioURL[i],
            ),
          ),
        );
      }
      final playlist = ConcatenatingAudioSource(
        shuffleOrder: DefaultShuffleOrder(),
        children: audioResourceSource,
      );

      await player.setAudioSource(playlist,
          initialIndex: index, initialPosition: Duration.zero);
      if (!dontPlayNow) {
        await player.play();
      } else {
        setState(() {
          isLoading = false;
          isPlaying = false;
          showFloatingControllers = false;
          playingIndex = -1;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isPlaying = false;
        showFloatingControllers = false;
        playingIndex = -1;
      });
      final connectivityResult = await Connectivity().checkConnectivity();
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) =>
            (connectivityResult.contains(ConnectivityResult.mobile) ||
                    connectivityResult.contains(ConnectivityResult.wifi) ||
                    connectivityResult.contains(ConnectivityResult.ethernet))
                ? AlertDialog(
                    title: const Text("Oops! Audio temporarily unavailable!"),
                    content: const Text(
                      "Thank you for using our app! It looks like the audio files are currently offline. We’re working hard to get everything back up and running smoothly. Please check back soon, and thank you for your patience and understanding!",
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  )
                : AlertDialog(
                    title: const Text("Oops! You have no internet connection"),
                    content: const Text(
                        "Note: When you play any ayah for the first time it will get downloaded from internet. Then it will stored as cached data in your local memory. You need internet connection now for play this audio."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  ),
      );
    }
  }

  List<String> getAllAudioUrl() {
    int start = widget.start ?? 0;
    int end = widget.end ?? allChaptersInfo[widget.surahNumber]['verses_count'];
    List<String> listOfURL = [];
    for (int i = start; i < end; i++) {
      listOfURL.add(getFullURL(i + 1));
    }
    return listOfURL;
  }

  String getBaseURLOfAudio(String rector) {
    List<String> splited = rector.split("(");
    String urlID = splited[1].replaceAll(")", "");
    String audioBaseURL = "https://everyayah.com/data/$urlID";
    return audioBaseURL;
  }

  String getIdOfAudio(int ayahNumber) {
    String suraString = "";
    if (widget.surahNumber < 10) {
      suraString = "00${widget.surahNumber + 1}";
    } else if (widget.surahNumber + 1 < 100) {
      suraString = "0${widget.surahNumber + 1}";
    } else {
      suraString = (widget.surahNumber + 1).toString();
    }
    String ayahString = "";

    if (ayahNumber < 10) {
      ayahString = "00$ayahNumber";
    } else if (ayahNumber < 100) {
      ayahString = "0$ayahNumber";
    } else {
      ayahString = ayahNumber.toString();
    }
    return suraString + ayahString;
  }

  int getAyahCountFromStart(int ayahNumber) {
    for (int i = 0; i < widget.surahNumber; i++) {
      int verseCount = allChaptersInfo[i]['verses_count'];
      ayahNumber += verseCount;
    }
    return ayahNumber;
  }

  String getFullURL(int ayahNumber) {
    final infoBox = Hive.box("info");
    final info = infoBox.get("info");
    String recitorChoice = info['recitation_ID'];
    String baseURL = getBaseURLOfAudio(recitorChoice);
    String audioID = getIdOfAudio(ayahNumber);
    return "$baseURL/$audioID.mp3";
  }

  void showInfomationOfSurah() async {
    final quranInfoBox = await Hive.openBox("quran_info");
    final infoBox = Hive.box("info");
    final info = infoBox.get("info", defaultValue: false);

    final quranInformation = quranInfoBox.get(
        "info_${info["translation_book_ID"]}/${widget.surahNumber + 1}/text",
        defaultValue: false);
    String text = "";
    String shortText = "";
    String source = "";

    if (quranInformation != false) {
      GZipDecoder decoder = GZipDecoder();
      text = utf8
          .decode(decoder.decodeBytes(base64Decode(quranInformation["text"])));
      shortText = quranInformation['short_text'];
      source = quranInformation['source'];
    }
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
            return Obx(
              () => ListView(
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
                  const Text(
                    "Source",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    source,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  const Text(
                    "Summary",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    shortText,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Text(
                    "In Detail",
                    style: TextStyle(
                      fontSize: controller.fontSizeTranslation.value,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  HtmlWidget(
                    text,
                    textStyle: TextStyle(
                      fontSize: controller.fontSizeTranslation.value,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          },
        );
      },
      isScrollControlled: true,
    );
  }

  Future<String> showTafseerOfAyah(
      int ayahNumber, String? surahName, bool goRoute) async {
    final tafseerBox = await Hive.openBox("tafseer");
    int ayahCountFromStart = getAyahCountFromStart(ayahNumber - 2);
    final infoBox = Hive.box("info");
    final info = infoBox.get("info", defaultValue: false);

    final tafseer =
        tafseerBox.get("${info['tafseer_book_ID']}/$ayahCountFromStart");
    GZipDecoder decoder = GZipDecoder();
    String decodedTafseer =
        utf8.decode(decoder.decodeBytes(base64Decode(tafseer)));

    if (goRoute) {
      Get.to(() => TafseerVoiceLess(
            fontS: controller.fontSizeTranslation.value,
            surahName: surahName,
            ayahNumber: ayahNumber,
            surahNumber: widget.surahNumber,
            tafseer: decodedTafseer,
          ));
    }
    return decodedTafseer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showFloatingControllers
          ? FloatingActionButton.extended(
              onPressed: null,
              label: expandFloatingControllers
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            player.seekToPrevious();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            if (player.playing) {
                              player.pause();
                            } else {
                              player.play();
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.green,
                            ),
                          ),
                          icon: isPlaying
                              ? const Icon(Icons.pause_rounded)
                              : const Icon(Icons.play_arrow_rounded),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () {
                            player.seekToNext();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () async {
                            if (!player.playing) {
                              setState(() {
                                showFloatingControllers = false;
                              });
                              List<String> listOfAudioURL = getAllAudioUrl();
                              playAudioList(listOfAudioURL, 0, true);
                            } else {
                              setState(() {
                                expandFloatingControllers = false;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          expandFloatingControllers = true;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
              extendedPadding: const EdgeInsets.all(5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
            )
          : null,
      body: Scrollbar(
        interactive: true,
        controller: scrollController,
        radius: const Radius.circular(7),
        thickness: 10,
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 40),
          children: listOfWidgetOfAyah(listOfAyah.length + 2),
        ),
      ),
    );
  }

  List<Widget> listOfWidgetOfAyah(int length) {
    List<Widget> listAyahWidget = [];

    int firstAyahNumber = getAyahCountFromStart(0);

    for (int index = 0; index < length; index++) {
      {
        if (index == 0) {
          String relevancePlace =
              allChaptersInfo[widget.surahNumber]['revelation_place'];
          int ayahNumber = allChaptersInfo[widget.surahNumber]['verses_count'];
          listAyahWidget.add(Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(15, 120, 120, 120),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(relevancePlace == 'makkah'
                            ? "assets/img/makkah.jpg"
                            : "assets/img/madina.jpeg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Revelation Place",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      relavencePlace![0].toUpperCase() +
                          relevancePlace.substring(1),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$ayahNumber Ayahs",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: showInfomationOfSurah,
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.green,
                            ),
                          ),
                          icon: const Icon(
                            Icons.info_outline_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 30,
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.green,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            if (player.playerState.processingState ==
                                ProcessingState.completed) {
                              setState(() {
                                showFloatingControllers = true;
                                playingIndex = 0;
                                isPlaying = true;
                              });
                              List<String> listOfAudioURL = getAllAudioUrl();
                              playAudioList(listOfAudioURL, 0);
                            }
                            if (!player.playing && playingIndex == -1) {
                              setState(() {
                                showFloatingControllers = true;
                                playingIndex = 0;
                                isPlaying = true;
                              });
                              List<String> listOfAudioURL = getAllAudioUrl();
                              playAudioList(listOfAudioURL, 0);
                            } else if (!player.playing) {
                              player.play();
                            } else {
                              player.pause();
                            }
                          },
                          icon: isPlaying
                              ? const Icon(Icons.pause_rounded)
                              : const Icon(Icons.play_arrow_rounded),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ));
        } else if (index == 1) {
          listAyahWidget.add(
            widget.surahNumber != 0
                ? Container(
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: getTazweedTexSpan(
                      startAyahBismillah(
                        controller.quranScriptTypeGetx.value,
                      ),
                      hideEnd: true,
                      doBold: true,
                    ),
                  )
                : const SizedBox(),
          );
        } else {
          final translation = Hive.box("translation");
          final quran = Hive.box('quran');
          int ayahNumber = listOfAyah[index - 2];
          final infoBox = Hive.box("info");
          final info = infoBox.get("info", defaultValue: false);

          String arbicAyah = quran.get("${ayahNumber + firstAyahNumber}");
          String ayahTranslation = translation.get(
              "${info["translation_book_ID"]}/${firstAyahNumber + listOfAyah[index - 2]}",
              defaultValue: "No Found");
          String bookName = "";
          for (var element in allTranslationLanguage) {
            if (element['id'].toString() == info['translation_book_ID']) {
              bookName = element['name'];
            }
          }
          String surahNumber = widget.surahNumber.toString();
          if (surahNumber.length == 1) {
            surahNumber = "00$surahNumber";
          } else if (surahNumber.length == 2) {
            surahNumber = "0$surahNumber";
          }
          String ayahNumberString = ayahNumber.toString();
          if (ayahNumberString.length == 1) {
            ayahNumberString = "00$ayahNumberString";
          } else if (ayahNumberString.length == 2) {
            ayahNumberString = "0$ayahNumberString";
          }
          String ayahKey = "$surahNumber:$ayahNumberString";

          listAyahWidget.add(
            Container(
              key: listOfkey[index - 2],
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(15, 120, 120, 120),
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(180, 134, 134, 134),
                        child: Text(
                          (listOfAyah[index - 2] + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.1),
                        ),
                        onSelected: (value) async {
                          if (value == "copy" || value == "copyWithTafseer") {
                            String allToCopy =
                                "${widget.surahName} ( ${widget.surahNumber + 1} : ${ayahNumber + 1} )\n\n$arbicAyah\n\n$ayahTranslation";

                            if (value == "copy") {
                              FlutterClipboard.copy(allToCopy);
                              return;
                            }

                            allToCopy +=
                                "\n\n${await showTafseerOfAyah(index, surahNameArabic, false)}";
                            FlutterClipboard.copy(allToCopy);
                          }
                          if (value == 'note') {
                            await Hive.openBox("notes");
                            Get.to(() => Notes(
                                  surahNumber: widget.surahNumber,
                                  ayahNumber: ayahNumber,
                                  surahName: widget.surahName,
                                ));
                          }

                          if (value == "bookmark") {
                            infoBox.put("bookmarkUploaded", false);
                            if (!(bookmarkSurahKey.contains(ayahKey))) {
                              setState(() {
                                bookmarkSurahKey.add(ayahKey);
                              });
                              final infoBox = Hive.box("info");
                              infoBox.put(value, bookmarkSurahKey);
                              showTwoestedMessage("Added to Book Mark");
                            } else {
                              setState(() {
                                bookmarkSurahKey.remove(ayahKey);
                              });
                              final infoBox = Hive.box("info");
                              infoBox.put(value, bookmarkSurahKey);
                              showTwoestedMessage("Removed from Book Mark");
                            }
                          }
                          if (value == "favorite") {
                            infoBox.put("favoriteUploaded", false);
                            if (!(favoriteSurahKey.contains(ayahKey))) {
                              setState(() {
                                favoriteSurahKey.add(ayahKey);
                              });
                              final infoBox = Hive.box("info");
                              infoBox.put(value, favoriteSurahKey);
                              showTwoestedMessage("Added to favorite");
                            } else {
                              setState(() {
                                favoriteSurahKey.remove(ayahKey);
                              });
                              final infoBox = Hive.box("info");
                              infoBox.put(value, favoriteSurahKey);
                              showTwoestedMessage("Removed from favorite");
                            }
                          }
                          if (value == 'tafsir') {
                            showTafseerOfAyah(index, surahNameArabic, true);
                          }
                        },
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        itemBuilder: (BuildContext bc) {
                          return [
                            const PopupMenuItem(
                              value: 'tafsir',
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.bookOpen,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('See Tafsir'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'favorite',
                              child: Row(
                                children: [
                                  favoriteSurahKey.contains(ayahKey)
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(favoriteSurahKey.contains(ayahKey)
                                      ? "Remove Favorite"
                                      : "Add Favorite"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'note',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.note_add,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Notes".tr),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'bookmark',
                              child: Row(
                                children: [
                                  bookmarkSurahKey.contains(ayahKey)
                                      ? const Icon(
                                          Icons.bookmark_added_rounded,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.bookmark,
                                          color: Colors.grey,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(bookmarkSurahKey.contains(ayahKey)
                                      ? "Remove BookMark"
                                      : "Add BookMark"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'copy',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Copy"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'copyWithTafseer',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Copy With Tafsir"),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                        iconSize: 30,
                        color: Colors.green,
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(60, 150, 150, 150),
                          ),
                        ),
                        onPressed: () {
                          if (playingIndex + 1 == index && player.playing) {
                            player.pause();
                          } else if (playingIndex + 1 == index) {
                            player.play();
                          } else {
                            setState(() {
                              showFloatingControllers = true;
                              isPlaying = true;
                              playingIndex = index - 2;
                            });
                            playAudioList(getAllAudioUrl(), index - 2);
                          }
                        },
                        icon: index == playingIndex + 2 && isPlaying
                            ? const Icon(Icons.pause_rounded)
                            : const Icon(Icons.play_arrow_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Obx(
                          () => buildArabicText(
                              controller.quranScriptTypeGetx.value,
                              "${ayahNumber + firstAyahNumber}",
                              ayahNumber),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Translation : $bookName",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Obx(
                        () => Text(
                          ayahTranslation,
                          style: TextStyle(
                            fontSize: controller.fontSizeTranslation.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
    return listAyahWidget;
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
