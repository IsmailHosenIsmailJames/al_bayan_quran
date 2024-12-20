import 'package:al_quran/src/theme/theme_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import 'init.dart';
import 'pages/choice_recitations.dart';
import 'pages/choice_tafseer_book.dart';
import 'getx/get_controller.dart';
import 'pages/choice_tranlation_book.dart';
import 'pages/tafseer_language.dart';
import 'pages/translation_language.dart';

class CollectInfoDesktop extends StatefulWidget {
  final int pageNumber;
  const CollectInfoDesktop({super.key, required this.pageNumber});

  @override
  State<CollectInfoDesktop> createState() => _CollectInfoDesktopState();
}

class _CollectInfoDesktopState extends State<CollectInfoDesktop> {
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
    return Scaffold(
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed: (infoController.recitationIndex.value != -1 &&
                  infoController.tafseerBookIndex.value != -1 &&
                  infoController.tafseerIndex.value != -1 &&
                  infoController.bookNameIndex.value != -1 &&
                  infoController.translationLanguage.value.isNotEmpty)
              ? () async {
                  {
                    Map<String, String> info = {
                      "translation_language":
                          infoController.translationLanguage.value,
                      "translation_book_ID":
                          infoController.bookIDTranslation.value,
                      "tafseer_language": infoController.tafseerLanguage.value,
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
              : null,
          label: const Center(
            child: Row(
              children: [
                Text("Done"),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Al Quran".tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Center(
              child: Text(
                "Choice your preference",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Spacer(),
          ],
        ),
        actions: [themeIconButton],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(flex: 3, child: TranslationLanguage()),
          Obx(() {
            if (infoController.translationLanguage.value.isNotEmpty) {
              return const Expanded(flex: 4, child: ChoiceTranslationBook());
            } else {
              return const SizedBox();
            }
          }),
          const Expanded(flex: 3, child: TafseerLanguage()),
          Obx(
            () {
              if (infoController.tafseerIndex.value != -1) {
                return const Expanded(flex: 4, child: ChoiceTafseerBook());
              } else {
                return const SizedBox();
              }
            },
          ),
          const Expanded(flex: 4, child: RecitationChoice()),
        ],
      ),
    );
  }
}
