import 'package:al_quran/src/collect_info/getx/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              String languageCode = used20LanguageMap[index]["Code"]!;
              languageController.changeLanguage = languageCode;
              final box = Hive.box("info");
              box.put("app_lan", languageCode);
              infoController.appLanCode.value = languageCode;
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(
                () => Row(
                  children: [
                    used20LanguageMap[index]['Code'] ==
                            infoController.appLanCode.value
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.green.shade600,
                          )
                        : Icon(
                            Icons.radio_button_off,
                            color: Colors.grey.shade700,
                          ),
                    const Gap(20),
                    Text(
                      used20LanguageMap[index]['Native'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
