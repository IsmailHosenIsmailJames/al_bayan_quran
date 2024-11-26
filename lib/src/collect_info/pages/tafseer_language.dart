import 'package:al_quran/src/collect_info/pages/choice_tafseer_book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class TafseerLanguage extends StatefulWidget {
  final bool? showAppBarNextButton;
  const TafseerLanguage({super.key, this.showAppBarNextButton});

  @override
  State<TafseerLanguage> createState() => _TafseerLanguageState();
}

class _TafseerLanguageState extends State<TafseerLanguage> {
  late List<String> language;
  void getLanguageList() {
    Set<String> temLanguages = {};
    for (int index = 0; index < allTafseer.length; index++) {
      String lanName = "${allTafseer[index]["language_name"]}";
      String tem = lanName[0];
      tem = tem.toUpperCase();
      lanName = tem + lanName.substring(1);
      temLanguages.add(lanName);
    }
    List<String> x = temLanguages.toList();
    x.sort();
    language = x;
  }

  @override
  void initState() {
    getLanguageList();
    super.initState();
  }

  final tafseerLanguage = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select language for Quran's Tafseer".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (widget.showAppBarNextButton == true)
            TextButton(
              onPressed: () {
                tafseerLanguage.tafseerBookIndex.value = -1;
                Navigator.pop(context);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return const ChoiceTafseerBook(
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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 100, top: 10, left: 3, right: 3),
        itemCount: language.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              int value = index;
              tafseerLanguage.tafseerIndex.value = value;
              tafseerLanguage.tafseerLanguage.value = language[value];
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey.withOpacity(0.07),
              ),
              child: ListTile(
                horizontalTitleGap: 5,
                title:
                    Text(language[index], style: const TextStyle(fontSize: 14)),
                leading: Obx(
                  () => Radio(
                    activeColor: Colors.green,
                    value: index,
                    groupValue: tafseerLanguage.tafseerIndex.value,
                    onChanged: (value) {
                      tafseerLanguage.tafseerIndex.value = value!;
                      tafseerLanguage.tafseerLanguage.value = language[value];
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
