import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class TranslationLanguage extends StatefulWidget {
  const TranslationLanguage({super.key});

  @override
  State<TranslationLanguage> createState() => _TranslationLanguageState();
}

class _TranslationLanguageState extends State<TranslationLanguage> {
  late List<String> language;
  void getLanguageList() {
    Set<String> temLangauge = {};
    for (int index = 0; index < allTranslationLanguage.length; index++) {
      String langName = "${allTranslationLanguage[index]["language_name"]}";
      String tem = langName[0];
      tem = tem.toUpperCase();
      langName = tem + langName.substring(1);
      temLangauge.add(langName);
    }
    List<String> tem = temLangauge.toList();
    tem.sort();
    language = tem;
  }

  @override
  void initState() {
    getLanguageList();
    super.initState();
  }

  final translationLanguageController = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choice a Translation Language")),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(bottom: 100, top: 10, left: 10, right: 10),
        itemCount: language.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              int value = index;
              translationLanguageController.selectedOptionTranslation.value =
                  value;
              translationLanguageController.translationLanguage.value =
                  language[value];
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index % 2 == 0
                      ? const Color.fromARGB(30, 131, 240, 255)
                      : const Color.fromARGB(30, 139, 255, 128)),
              child: ListTile(
                title: Text(
                  language[index],
                ),
                leading: Obx(
                  () => Radio(
                    value: index,
                    groupValue: translationLanguageController
                        .selectedOptionTranslation.value,
                    onChanged: (value) {
                      translationLanguageController
                          .selectedOptionTranslation.value = value!;
                      translationLanguageController.translationLanguage.value =
                          language[value];
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
