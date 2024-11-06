import 'dart:developer';

import 'package:al_bayan_quran/src/collect_info/pages/choice_tranlation_book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class TranslationLanguage extends StatefulWidget {
  final bool? showNextButtonOnAppBar;
  const TranslationLanguage({super.key, this.showNextButtonOnAppBar});

  @override
  State<TranslationLanguage> createState() => _TranslationLanguageState();
}

class _TranslationLanguageState extends State<TranslationLanguage> {
  late List<String> language;
  void getLanguageList() {
    Set<String> temLanguages = {};
    for (int index = 0; index < allTranslationLanguage.length; index++) {
      String langName = "${allTranslationLanguage[index]["language_name"]}";
      // if()
      String tem = langName[0];
      tem = tem.toUpperCase();
      langName = tem + langName.substring(1);
      temLanguages.add(langName);
    }
    List<String> tem = temLanguages.toList();
    tem.sort();
    language = tem;
    log(language.toString());
  }

  @override
  void initState() {
    getLanguageList();
    super.initState();
  }

  final translationLanguageController = Get.put(InfoController());

  Map<String, String> nativeName = {
    "Albanian": "Shqip",
    "Amazigh": "Tamazight",
    "Amharic": "አማርኛ",
    "Assamese": "অসমীয়া",
    "Azeri": "Azərbaycan dili",
    "Bambara": "Bamanankan",
    "Bengali": "বাংলা",
    "Bosnian": "Bosanski",
    "Bulgarian": "български",
    "Central Khmer": "ភាសាខ្មែរ",
    "Chechen": "Нохчийн мотт",
    "Chinese": "中文",
    "Czech": "Čeština",
    "Dari": "دری",
    "Divehi": "ދިވެހި",
    "Dutch": "Nederlands",
    "English": "English",
    "Finnish": "Suomi",
    "French": "Français",
    "Ganda": "Luganda",
    "German": "Deutsch",
    "Gujarati": "ગુજરાતી",
    "Hausa": "Hausa",
    "Hebrew": "עברית",
    "Hindi": "हिन्दी",
    "Indonesian": "Bahasa Indonesia",
    "Italian": "Italiano",
    "Japanese": "日本語",
    "Kannada": "ಕನ್ನಡ",
    "Kazakh": "Қазақ тілі",
    "Kinyarwanda": "Ikinyarwanda",
    "Korean": "한국어",
    "Kurdish": "Kurdî",
    "Malay": "Bahasa Melayu",
    "Malayalam": "മലയാളം",
    "Maranao": "Mëranaw",
    "Marathi": "मराठी",
    "Nepali": "नेपाली",
    "Norwegian": "Norsk",
    "Oromo": "Afaan Oromoo",
    "Pashto": "پښتو",
    "Persian": "فارسی",
    "Polish": "Polski",
    "Portuguese": "Português",
    "Romanian": "Română",
    "Russian": "Русский",
    "Sindhi": "سنڌي",
    "Sinhala": "සිංහල",
    "Somali": "Soomaaliga",
    "Spanish": "Español",
    "Swahili": "Kiswahili",
    "Swedish": "Svenska",
    "Tagalog": "Tagalog",
    "Tajik": "Тоҷикӣ",
    "Tamil": "தமிழ்",
    "Tatar": "Татарча",
    "Telugu": "తెలుగు",
    "Thai": "ไทย",
    "Turkish": "Türkçe",
    "Uighur": "Uyghurche",
    "Ukrainian": "Українська",
    "Urdu": "اردو",
    "Uzbek": "O‘zbekcha",
    "Vietnamese": "Tiếng Việt",
    "Yoruba": "Yorùbá"
  };

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Translation of Quran".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (widget.showNextButtonOnAppBar == true)
            TextButton(
              onPressed: () {
                translationLanguageController.bookNameIndex.value = -1;
                Navigator.pop(context);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return const ChoiceTranslationBook(
                      showDownloadOnAppbar: true,
                    );
                  },
                );
              },
              child: const Text(
                "NEXT",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            height: 50,
            child: CupertinoSearchTextField(
              onChanged: (value) {
                value = value.toLowerCase();
                Set<String> languageSetForSearch = {};
                for (var e in language) {
                  if (e.toLowerCase().contains(value)) {
                    languageSetForSearch.add(e);
                  }
                }
                nativeName.forEach(
                  (key, v) {
                    if (v.toLowerCase().contains(value)) {
                      languageSetForSearch.add(key);
                    }
                  },
                );
                List<String> tem = languageSetForSearch.toList();
                tem.sort();

                setState(() {
                  language = tem;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(
                  bottom: 100, top: 10, left: 10, right: 10),
              itemCount: language.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    translationLanguageController.translationLanguage.value =
                        language[index];
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withOpacity(0.07),
                      ),
                      child: Row(
                        children: [
                          translationLanguageController
                                      .translationLanguage.value ==
                                  language[index]
                              ? const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.radio_button_unchecked,
                                ),
                          const Gap(15),
                          Text(
                            nativeName.keys.contains(language[index])
                                ? nativeName[language[index]] ?? ""
                                : language[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: translationLanguageController
                                          .translationLanguage.value ==
                                      language[index]
                                  ? Colors.green.shade700
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
