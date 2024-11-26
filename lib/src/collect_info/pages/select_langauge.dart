import 'package:al_quran/src/collect_info/getx/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../translations/language_controller.dart';
import '../../translations/map_of_translation.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLangaugeState();
}

class _SelectLangaugeState extends State<SelectLanguage> {
  final languageController = Get.put(LanguageController());
  final infoController = Get.put(InfoController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select a language for app".tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 100, top: 10),
        itemCount: used20LanguageMap.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                backgroundColor: Colors.green.shade400.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: () {
                String languageCode = used20LanguageMap[index]["Code"]!;
                languageController.changeLanguage = languageCode;
                final box = Hive.box("info");
                box.put("app_lan", languageCode);
                infoController.appLanCode.value = languageCode;
              },
              child: Obx(
                () => Row(
                  children: [
                    Text(
                      used20LanguageMap[index]['Native'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    if (used20LanguageMap[index]['Code'] ==
                        infoController.appLanCode.value)
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
