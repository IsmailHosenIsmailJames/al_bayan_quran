import 'package:al_bayan_quran/src/collect_info/pages/intro.dart';
import 'package:al_bayan_quran/src/core/show_twoested_message.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme_icon_button.dart';
import 'init.dart';
import 'pages/choice_recitations.dart';
import 'pages/choice_tafseer_book.dart';
import 'getx/get_controller.dart';
import 'pages/choice_tranlation_book.dart';
import 'pages/tafseer_language.dart';
import 'pages/translation_language.dart';

class CollectInfoMobile extends StatefulWidget {
  final int pageNumber;
  const CollectInfoMobile({super.key, required this.pageNumber});

  @override
  State<CollectInfoMobile> createState() => _CollectInfoMobileState();
}

class _CollectInfoMobileState extends State<CollectInfoMobile> {
  late int indexPage;
  String nextButtonText = "Next";

  @override
  void initState() {
    indexPage = widget.pageNumber;
    pageIndex = widget.pageNumber;
    super.initState();
  }

  final infoController = Get.put(InfoController());
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Al Quran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (width > 430)
              const Center(
                child: Text(
                  "Choice your preference",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            const Spacer(),
            TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"),
                );
              },
              child: const Text("Privacy Policy"),
            ),
          ],
        ),
        actions: [themeIconButton],
      ),
      body: Column(
        children: [
          Expanded(
            child: [
              const Intro(),
              const TranslationLanguage(),
              const ChoiceTranslationBook(),
              const TafseerLanguage(),
              const ChoiceTafseerBook(),
              const RecitationChoice(),
            ][pageIndex],
          ),
          Container(
            margin: const EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 10, right: 10)),
                  onPressed: pageIndex != 0
                      ? () {
                          if (pageIndex > 0) {
                            setState(() {
                              pageIndex--;
                            });
                          }
                        }
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_outlined,
                        color: pageIndex != 0 ? Colors.green : Colors.grey,
                        size: 15,
                      ),
                      const Gap(5),
                      Text(
                        "Previous",
                        style: textTheme.bodyMedium!.copyWith(
                          color: pageIndex != 0 ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    getPageIndicator(0, pageIndex),
                    getPageIndicator(1, pageIndex),
                    getPageIndicator(2, pageIndex),
                    getPageIndicator(3, pageIndex),
                    getPageIndicator(4, pageIndex),
                    getPageIndicator(5, pageIndex),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 10, right: 10)),
                  onPressed: () async {
                    if (pageIndex == 1) {
                      if (infoController.translationLanguage.value.isEmpty) {
                        showTwoestedMessage(
                            "Please Select Quran Translation Language");
                        return;
                      }
                    } else if (pageIndex == 2) {
                      if (infoController.bookNameIndex.value == -1) {
                        showTwoestedMessage(
                            "Please Select Quran Translation Book");
                        return;
                      }
                    }
                    if (pageIndex == 3) {
                      if (infoController.tafseerIndex.value == -1) {
                        showTwoestedMessage(
                            "Please Select Quran Tafsir Language");
                        return;
                      }
                    } else if (pageIndex == 4) {
                      if (infoController.tafseerBookIndex.value == -1) {
                        showTwoestedMessage("Please Select Quran Tafsir Book");
                        return;
                      }
                    } else if (pageIndex == 5) {
                      if (infoController.recitationIndex.value != -1 &&
                          infoController.tafseerBookIndex.value != -1 &&
                          infoController.tafseerIndex.value != -1 &&
                          infoController.bookNameIndex.value != -1 &&
                          infoController.translationLanguage.value.isNotEmpty) {
                        Map<String, String> info = {
                          "translation_language":
                              infoController.translationLanguage.value,
                          "translation_book_ID":
                              infoController.bookIDTranslation.value,
                          "tafseer_language":
                              infoController.tafseerLanguage.value,
                          "tafseer_book_ID": infoController.tafseerBookID.value,
                          "recitation_ID": infoController.recitationName.value,
                        };
                        if (Hive.isBoxOpen("info")) {
                          final box = Hive.box("info");

                          box.put("info", info);
                          Get.offAll(() => const InIt());
                        } else {
                          final box = await Hive.openBox("info");

                          box.put("info", info);
                          Get.offAll(() => const InIt());
                        }
                      }
                    }
                    if (pageIndex < 5) {
                      setState(() {
                        pageIndex++;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        pageIndex == 0 ? "Setup" : nextButtonText,
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(5),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.green,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPageIndicator(int index, int page) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CircleAvatar(
        radius: index == page ? 7 : 4,
        backgroundColor: index == page ? Colors.green : Colors.grey,
      ),
    );
  }
}
