import 'dart:convert';
import 'package:al_quran/src/core/show_twoested_message.dart';
import 'package:al_quran/src/screens/getx_controller.dart';
import 'package:al_quran/src/screens/home_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class ChoiceTranslationBook extends StatefulWidget {
  final bool? showDownloadOnAppbar;
  const ChoiceTranslationBook({super.key, this.showDownloadOnAppbar});

  @override
  State<ChoiceTranslationBook> createState() => _ChoiceTranslationStateBook();
}

class _ChoiceTranslationStateBook extends State<ChoiceTranslationBook> {
  final infoController = Get.put(InfoController());
  final fontHandler = Get.put(ScreenGetxController());
  List<List<String>> books = [];
  void getBooksAsLanguage() {
    for (int i = 0; i < allTranslationLanguage.length; i++) {
      Map<String, dynamic> book = allTranslationLanguage[i];
      if (book['language_name'].toString().toLowerCase() ==
          infoController.translationLanguage.value.toLowerCase()) {
        String author = book['author_name'];
        String bookName = book['name'];
        String id = book['id'].toString();
        books.add([author, bookName, id]);
      }
    }
  }

  @override
  void initState() {
    getBooksAsLanguage();
    super.initState();
  }

  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Translation Book".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        actions: [
          if (widget.showDownloadOnAppbar == true)
            downloading
                ? const CircularProgressIndicator()
                : TextButton.icon(
                    onPressed: () async {
                      if (infoController.translationLanguage.value.isNotEmpty) {
                        final dataBox = Hive.box("data");
                        final infoBox = Hive.box("info");
                        String bookTranslationID =
                            infoController.bookIDTranslation.value;
                        if (bookTranslationID ==
                            infoBox.get("info")['translation_book_ID']) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Wrong Selection"),
                                content: const Text(
                                    "Your selection can't matched with the previous selection."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              );
                            },
                          );
                          return;
                        }

                        dataBox.put("translation", false);
                        setState(() {
                          downloading = true;
                        });

                        var url = Uri.parse(
                            "https://api.quran.com/api/v4/quran/translations/${infoController.bookIDTranslation.value}");
                        var headers = {"Accept": "application/json"};

                        var response = await http.get(url, headers: headers);

                        if (response.statusCode == 200) {
                          List<Map<String, dynamic>> translation =
                              List<Map<String, dynamic>>.from(
                                  json.decode(response.body)['translations']);

                          final translationBox =
                              await Hive.openBox("translation");

                          for (int i = 0; i < translation.length; i++) {
                            translationBox.put(
                              "$bookTranslationID/$i",
                              translation[i]['text'].toString(),
                            );
                          }
                        }
                        final info = infoBox.get("info", defaultValue: false);
                        info['translation_book_ID'] =
                            bookTranslationID.toString();
                        info['translation_language'] =
                            infoController.translationLanguage.value;
                        infoBox.put("info", info);
                        dataBox.put("translation", true);
                        infoBox.put('translation', bookTranslationID);

                        Get.offAll(() => const HomeMobile());
                        showTwoestedMessage("Successful");
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Select a Book First"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding:
            const EdgeInsets.only(bottom: 100, top: 10, left: 10, right: 10),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
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
                int value = index;
                infoController.bookNameIndex.value = value;
                infoController.bookIDTranslation.value = books[value][2];
              },
              child: Obx(
                () => Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          books[index][1],
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          books[index][0],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (infoController.bookNameIndex.value == index)
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
