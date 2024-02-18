import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class TafseerLanguage extends StatefulWidget {
  const TafseerLanguage({super.key});

  @override
  State<TafseerLanguage> createState() => _TafseerLanguageState();
}

class _TafseerLanguageState extends State<TafseerLanguage> {
  late List<String> language;
  void getLanguageList() {
    Set<String> temLangauge = {};
    for (int index = 0; index < allTafseer.length; index++) {
      String lanName = "${allTafseer[index]["language_name"]}";
      String tem = lanName[0];
      tem = tem.toUpperCase();
      lanName = tem + lanName.substring(1);
      temLangauge.add(lanName);
    }
    List<String> x = temLangauge.toList();
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
      appBar: AppBar(title: const Text("Choice a Tafseer Language")),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(bottom: 100, top: 10, left: 10, right: 10),
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
                  borderRadius: BorderRadius.circular(10),
                  color: index % 2 == 0
                      ? const Color.fromARGB(30, 131, 240, 255)
                      : const Color.fromARGB(30, 139, 255, 128)),
              child: ListTile(
                title: Text(language[index]),
                leading: Obx(
                  () => Radio(
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
