import 'dart:convert';

import 'package:al_bayan_quran/data/download/links.dart';
import 'package:al_bayan_quran/screens/home.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class DownloadData extends StatefulWidget {
  const DownloadData({super.key});

  @override
  State<DownloadData> createState() => _DownloadDataState();
}

class _DownloadDataState extends State<DownloadData> {
  double progressValue = 0.0;

  void getData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      progressValue = 0.01;
    });
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text(
              "We need to download required data.\nMake sure you are connected with internet."),
          actions: [
            TextButton(
              onPressed: () {
                getData();
              },
              child: const Icon(
                Icons.restart_alt_outlined,
              ),
            ),
          ],
        ),
      );
    } else {
      final infoBox = Hive.box("info");
      final info = infoBox.get("info", defaultValue: false);
      if (info != false) {
        Map<String, String> preferance = {
          "translation_language": info['translation_language'],
          "translation_book_ID": info["translation_book_ID"],
          "tafseer_language": info['tafseer_language'],
          "tafseer_book_ID": info["tafseer_book_ID"],
          "recitation_ID": info['recitation_ID']
        };

        if (infoBox.get('quran_info', defaultValue: false) == false) {
          setState(() {
            progressValue = 0.02;
          });
          final quraninforbox = await Hive.openBox("quran_info");
          for (int i = 1; i < 115; i++) {
            var url = Uri.parse(
                "https://api.quran.com/api/v4/chapters/$i/info?language=${preferance['translation_language']!.toLowerCase()}");
            var headers = {"Accept": "application/json"};

            var response = await http.get(url, headers: headers);
            if (response.statusCode == 200) {
              setState(() {
                progressValue += 0.005877;
              });
              final jsonBody = jsonDecode(response.body);
              Map<String, dynamic> infomationChapter =
                  Map<String, dynamic>.from(jsonBody["chapter_info"]);

              GZipEncoder encoder = GZipEncoder();
              List<int>? encoded =
                  encoder.encode(utf8.encode(infomationChapter['text']));

              if (encoded != null) {
                infomationChapter['text'] = base64Encode(encoded);
                quraninforbox.put(
                  "info_${preferance['translation_book_ID']}/$i/text",
                  infomationChapter,
                );
              } else {
                quraninforbox.put(
                  "info_${preferance['translation_book_ID']}/$i/text",
                  "Nothing Found",
                );
              }
            }
          }
          final dataBoox = Hive.box("data");
          dataBoox.put("quran_info", true);
          infoBox.put('quran_info', true);
        }

        if (infoBox.get('quran', defaultValue: false) == false) {
          setState(() {
            progressValue = 0.60;
          });
          var url = Uri.parse(
              "https://api.quran.com/api/v4/quran/verses/uthmani_tajweed");
          var headers = {"Accept": "application/json"};

          var response = await http.get(url, headers: headers);
          if (response.statusCode == 200) {
            setState(() {
              progressValue = 0.61;
            });
            List<Map<String, dynamic>> listMap =
                List<Map<String, dynamic>>.from(
                    jsonDecode(response.body)['verses']);
            final quranTajweed = await Hive.openBox("quran_tajweed");
            for (int i = 0; i < listMap.length; i++) {
              quranTajweed.put("$i", listMap[i]['text_uthmani_tajweed']);
            }
          }
          url = Uri.parse("https://api.quran.com/api/v4/quran/verses/uthmani");
          headers = {"Accept": "application/json"};

          response = await http.get(url, headers: headers);

          if (response.statusCode == 200) {
            setState(() {
              progressValue = 0.63;
            });
            List<Map<String, dynamic>> listMap =
                List<Map<String, dynamic>>.from(
                    jsonDecode(response.body)['verses']);
            final quranTajweed = await Hive.openBox("quran");
            for (int i = 0; i < listMap.length; i++) {
              quranTajweed.put("$i", listMap[i]['text_uthmani']);
            }
            setState(() {
              progressValue = 0.64;
            });
          }

          final dataBoox = Hive.box("data");
          dataBoox.put("quran", true);
          infoBox.put('quran', true);
        } else {
          setState(() {
            progressValue = 0.64;
          });
        }

        if (infoBox.get('translation', defaultValue: false) == false ||
            infoBox.get('translation', defaultValue: false) !=
                preferance['translation_book_ID']) {
          var url = Uri.parse(
              "https://api.quran.com/api/v4/quran/translations/${preferance['translation_book_ID']}");
          var headers = {"Accept": "application/json"};

          var response = await http.get(url, headers: headers);

          if (response.statusCode == 200) {
            setState(() {
              progressValue = 0.65;
            });

            List<Map<String, dynamic>> translation =
                List<Map<String, dynamic>>.from(
                    json.decode(response.body)['translations']);

            setState(() {
              progressValue = 0.67;
            });
            final translationBox = await Hive.openBox("translation");

            for (int i = 0; i < translation.length; i++) {
              translationBox.put(
                "${preferance['translation_book_ID']}/$i",
                translation[i]['text'].toString(),
              );
            }
            setState(() {
              progressValue = 0.68;
            });

            final dataBoox = Hive.box("data");
            dataBoox.put("translation", true);
            infoBox.put('translation', preferance['translation_book_ID']);
          } else {
            setState(() {});
          }
        } else {
          setState(() {
            progressValue = 0.69;
          });
        }
        if (infoBox.get('tafseer', defaultValue: false) == false ||
            infoBox.get('tafseer', defaultValue: false) !=
                preferance['tafseer_book_ID']) {
          setState(() {
            progressValue = 0.75;
          });

          final tafseerBox = await Hive.openBox("tafseer");
          final url = Uri.parse(tafseerLinks[preferance['tafseer_book_ID']]!);
          final headers = {"Accept": "application/json"};
          final response = await http.get(url, headers: headers);
          setState(() {
            progressValue = 0.95;
          });
          if (response.statusCode == 200) {
            final tafseer = json.decode(response.body);
            for (int i = 0; i < 6236; i++) {
              String? ayah = tafseer['$i'];
              if (ayah != null) {
                tafseerBox.put(
                  "${preferance['tafseer_book_ID']}/$i",
                  tafseer["$i"],
                );
              }
            }
            final dataBoox = Hive.box("data");
            dataBoox.put("tafseer", true);
            infoBox.put('tafseer', preferance['tafseer_book_ID']);
          }
        }

        Get.offAll(() => const Home());
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Please Wait\nDownloading...\nIt will take around 30 sec.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Progress : ${(progressValue * 100).toInt()}%"),
          ],
        ),
      ),
    );
  }
}
