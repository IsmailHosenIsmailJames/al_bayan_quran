import 'dart:convert';

import 'package:al_bayan_quran/auth/login/login.dart';
import 'package:al_bayan_quran/theme/theme_controller.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Notes extends StatefulWidget {
  final int surahNumber;
  final int ayahNumber;
  final String? surahName;
  const Notes(
      {super.key,
      required this.surahNumber,
      this.surahName,
      required this.ayahNumber});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  bool isUploaded = false;
  late Widget cludUploadIdicator;

  @override
  void initState() {
    cludUploadIdicator = IconButton(
      onPressed: () {
        uploadNotes();
      },
      icon: const Icon(
        Icons.cloud_upload_sharp,
      ),
    );
    String keyOfAyah = "${widget.surahNumber + 1}${widget.ayahNumber + 1}";

    final box = Hive.box("notes");
    String boxKeyForTitle = "${keyOfAyah}title";
    String boxKeyForNote = "${keyOfAyah}note";
    final note = box.get(boxKeyForNote, defaultValue: null);
    final title = box.get(boxKeyForTitle, defaultValue: null);
    if (note != null) {
      setState(() {
        controller2.text = note;
      });
    }
    if (title != null) {
      setState(() {
        controller1.text = title;
      });
    }
    String boxKeyForNoteUpload =
        "${widget.surahNumber + 1}:${widget.ayahNumber + 1}upload";

    final isUploadedData = box.get(boxKeyForNoteUpload, defaultValue: null);
    if (isUploadedData != null && isUploadedData != false) {
      setState(() {
        isUploaded = true;
      });
    }

    super.initState();
  }

  void autoSave() {
    String keyOfAyah = "${widget.surahNumber + 1}${widget.ayahNumber + 1}";

    final box = Hive.box("notes");
    String boxKeyForTitle = "${keyOfAyah}title";
    String boxKeyForNote = "${keyOfAyah}note";

    if (controller2.text.isNotEmpty) {
      box.put(boxKeyForNote, controller2.text);
    }
    if (controller1.text.isNotEmpty) {
      box.put(boxKeyForTitle, controller1.text);
    }
  }

  void uploadNotes() async {
    String keyOfAyah = "${widget.surahNumber + 1}${widget.ayahNumber + 1}";
    if (isLoogedIn == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login First"),
          content: const Text(
              "You must logged in first to upload notes and access them from any device"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.offAll(() => const LogIn());
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        cludUploadIdicator = const CircularProgressIndicator(
          color: Colors.green,
        );
      });
      Client client = Client()
          .setEndpoint("https://cloud.appwrite.io/v1")
          .setProject("albayanquran")
          .setSelfSigned(status: true);

      Databases databases = Databases(client);

      try {
        autoSave();

        final account = Account(client);
        final user = await account.get();

        try {
          final document = await databases.getDocument(
              databaseId: "65bf585cdf62317b4d91",
              collectionId: "65bfa12aa542dc981ea8",
              documentId: user.$id);
          List listOfKey = jsonDecode(document.data['allnotes']);
          if (!listOfKey.contains(keyOfAyah)) {
            listOfKey.add(keyOfAyah);
          }

          await databases.updateDocument(
              databaseId: "65bf585cdf62317b4d91",
              collectionId: "65bfa12aa542dc981ea8",
              documentId: user.$id,
              data: {"allnotes": jsonEncode(listOfKey)});
        } catch (e) {
          await databases.createDocument(
              databaseId: "65bf585cdf62317b4d91",
              collectionId: "65bfa12aa542dc981ea8",
              documentId: user.$id,
              data: {
                "allnotes": jsonEncode([keyOfAyah])
              });
        }

        try {
          await databases.updateDocument(
            databaseId: "65bf585cdf62317b4d91",
            collectionId: "65d1ca40a427099b17f1",
            documentId: "${user.$id}$keyOfAyah",
            data: <String, String>{
              "title": controller1.text,
              "note": controller2.text,
            },
          );
        } catch (e) {
          await databases.createDocument(
            databaseId: "65bf585cdf62317b4d91",
            collectionId: "65d1ca40a427099b17f1",
            documentId: "${user.$id}$keyOfAyah",
            data: <String, String>{
              "title": controller1.text,
              "note": controller2.text,
            },
          );
        }
        String boxKeyForNoteUpload = "${keyOfAyah}upload";
        final box = Hive.box("notes");

        box.put(boxKeyForNoteUpload, true);
        setState(() {
          isUploaded = true;
        });
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("An Error Occured"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      setState(() {
        cludUploadIdicator = IconButton(
          onPressed: () {
            uploadNotes();
          },
          icon: const Icon(
            Icons.cloud_upload_sharp,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes for ${widget.surahName} (    ${widget.surahNumber + 1}${widget.ayahNumber + 1})",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              autoSave();
            },
            icon: const Icon(Icons.done),
          ),
          isUploaded ? const Icon(Icons.cloud_done_rounded) : cludUploadIdicator
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller1,
              onFieldSubmitted: (value) {
                focusNode2.requestFocus();
                autoSave();
              },
              focusNode: focusNode1,
              onChanged: (value) {
                String boxKeyForNoteUpload =
                    "${widget.surahNumber + 1}${widget.ayahNumber + 1}upload";
                final box = Hive.box("notes");
                box.put(boxKeyForNoteUpload, false);
                setState(() {
                  isUploaded = false;
                });
                autoSave();
              },
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              minLines: 5,
              maxLines: null,
              focusNode: focusNode2,
              onFieldSubmitted: (value) => autoSave(),
              onChanged: (value) {
                String boxKeyForNoteUpload =
                    "${widget.surahNumber + 1}${widget.ayahNumber + 1}upload";
                final box = Hive.box("notes");
                box.put(boxKeyForNoteUpload, false);
                setState(() {
                  isUploaded = false;
                });
                autoSave();
              },
              decoration: InputDecoration(
                  labelText: "Your note",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              controller: controller2,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
