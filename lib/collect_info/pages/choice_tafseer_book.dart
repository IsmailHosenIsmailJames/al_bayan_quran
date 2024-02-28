import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/some_api_response.dart';
import '../getx/get_controller.dart';

class ChoiceTafseerBook extends StatefulWidget {
  const ChoiceTafseerBook({super.key});

  @override
  State<ChoiceTafseerBook> createState() => _ChoiceTafseerBookState();
}

class _ChoiceTafseerBookState extends State<ChoiceTafseerBook> {
  final infoController = Get.put(InfoController());
  List<List<String>> books = [];
  void getBooksAsLanguage() {
    for (int i = 0; i < allTafseer.length; i++) {
      Map<String, dynamic> book = allTafseer[i];
      if (book['language_name'].toString().toLowerCase() ==
          infoController.tafseerLanguage.value.toLowerCase()) {
        String autor = book['author_name'];
        String bookName = book['name'];
        String id = book['id'].toString();
        books.add([autor, bookName, id]);
      }
    }
  }

  @override
  void initState() {
    getBooksAsLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Tafseer Book",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      )),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 100, top: 10, left: 3, right: 3),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              int value = index;
              infoController.tafseerBookIndex.value = value;
              infoController.tafseerBookID.value = books[value][2];
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(10, 145, 255, 160),
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      books[index][1],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      books[index][0],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                leading: Obx(
                  () => Radio(
                    activeColor: Colors.green,
                    value: index,
                    groupValue: infoController.tafseerBookIndex.value,
                    onChanged: (value) {
                      infoController.tafseerBookIndex.value = value!;
                      infoController.tafseerBookID.value = books[value][2];
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
