import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  late PageController pageController;
  late int indexPage;
  String nextButtonText = "Next";
  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageNumber);
    indexPage = widget.pageNumber;
    checkPageNumber(widget.pageNumber);
    super.initState();
  }

  void checkPageNumber(int index) {
    if (index >= 4) {
      setState(() {
        nextButtonText = "Done";
      });
    } else {
      setState(() {
        nextButtonText = "Next";
      });
    }
  }

  final infoController = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Al Bayan Quran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (width > 430)
              const Center(
                child: Text(
                  "Choice your preferance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            const Spacer(),
          ],
        ),
        actions: [themeIconButton],
      ),
      body: Stack(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            children: const [
              TranslationLanguage(),
              ChoiceTranslationBook(),
              TafseerLanguage(),
              ChoiceTafseerBook(),
              RecitaionChoice(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Color.fromARGB(100, 125, 125, 125),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 5,
                    onDotClicked: (index) {
                      pageController.jumpToPage(
                        index,
                      );
                      checkPageNumber(index);
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      if (pageController.page! == 0) {
                        if (infoController.selectedOptionTranslation.value ==
                            -1) {
                          return;
                        }
                      } else if (pageController.page! == 1) {
                        if (infoController.bookNameIndex.value == -1) {
                          return;
                        }
                      }
                      if (pageController.page! == 2) {
                        if (infoController.tafseerIndex.value == -1) {
                          return;
                        }
                      } else if (pageController.page! == 3) {
                        if (infoController.tafseerBookIndex.value == -1) {
                          return;
                        }
                      } else if (pageController.page! == 4) {
                        if (infoController.recitationIndex.value != -1 &&
                            infoController.tafseerBookIndex.value != -1 &&
                            infoController.tafseerIndex.value != -1 &&
                            infoController.bookNameIndex.value != -1 &&
                            infoController.selectedOptionTranslation.value !=
                                -1) {
                          Map<String, String> info = {
                            "translation_language":
                                infoController.translationLanguage.value,
                            "translation_book_ID":
                                infoController.bookIDTranslation.value,
                            "tafseer_language":
                                infoController.tafseerLanguage.value,
                            "tafseer_book_ID":
                                infoController.tafseerBookID.value,
                            "recitation_ID":
                                infoController.recitationName.value,
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
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.bounceIn);
                      checkPageNumber(pageController.page!.toInt() + 1);
                    },
                    child: Text(nextButtonText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
