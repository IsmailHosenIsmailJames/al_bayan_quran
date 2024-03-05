import 'dart:convert';

import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:al_bayan_quran/screens/favorite_bookmark_notes/get_data.dart';
import 'package:al_bayan_quran/screens/favorite_bookmark_notes/notes_get_data.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../auth/account_info/account_info.dart';
import '../../auth/login/login.dart';
import '../../theme/theme_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  List<int> expandedPosition = [];
  List<AnimationController> controller = [];
  List<Animation<double>> sizeAnimation = [];
  List<Widget> favorite = buildWidgetForFavBook("favorite");
  List<Widget> bookmark = buildWidgetForFavBook("bookmark");
  List<Widget> notes = buildListOfWidgetForNotes();
  bool bookmarkDone = false;
  bool favoriteDone = false;
  bool notesDone = false;

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      final tem = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );
      controller.add(tem);
      sizeAnimation.add(CurvedAnimation(parent: tem, curve: Curves.easeInOut));
      expandedPosition.add(-1);
    }

    final infoBox = Hive.box("info");
    favoriteDone = infoBox.get("favoriteUploaded", defaultValue: false);
    bookmarkDone = infoBox.get("bookmarkUploaded", defaultValue: false);
    final notes = Hive.box("notes");
    for (String key in notes.keys) {
      if (key.endsWith("title")) {
        String ayahKey = key.substring(0, 6);
        notesDone = notes.get(
          "${ayahKey}upload",
          defaultValue: false,
        );
        setState(() {
          notesDone;
        });
        if (notesDone == false) {
          break;
        }
      }
    }
    super.initState();
  }

  Future<void> uploadNotes(String keyOfAyah, titleText, notesText) async {
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("albayanquran")
        .setSelfSigned(status: true);

    Databases databases = Databases(client);

    try {
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
            "title": titleText,
            "note": notesText,
          },
        );
      } catch (e) {
        await databases.createDocument(
          databaseId: "65bf585cdf62317b4d91",
          collectionId: "65d1ca40a427099b17f1",
          documentId: "${user.$id}$keyOfAyah",
          data: <String, String>{
            "title": titleText,
            "note": notesText,
          },
        );
      }
      String boxKeyForNoteUpload = "${keyOfAyah}upload";
      final box = Hive.box("notes");

      box.put(boxKeyForNoteUpload, true);
      setState(() {
        notesDone = true;
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
  }

  void uploadAll() async {
    if (notesDone != true) {
      final notesBox = Hive.box("notes");
      for (String key in notesBox.keys) {
        if (key.endsWith("title") || key.endsWith("note")) {
          String ayahKey = key.substring(0, 6);
          String n = notesBox.get("${ayahKey}note", defaultValue: "");
          String t = notesBox.get("${ayahKey}title", defaultValue: "");
          if (!(notesBox.get("${ayahKey}upload", defaultValue: false))) {
            await uploadNotes(ayahKey, t, n);
          } else {
            print("object");
          }
          print("");
        }
      }
    }
    final infbox = Hive.box("info");
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("albayanquran")
        .setSelfSigned(status: true);
    final account = Account(client);
    final user = await account.get();
    Databases databases = Databases(client);

    if (favoriteDone != true) {
      try {
        await databases.updateDocument(
          databaseId: "65bf585cdf62317b4d91",
          collectionId: "65bfa12aa542dc981ea8",
          documentId: user.$id,
          data: {
            "favorite": jsonEncode(
              infbox.get("favorite", defaultValue: []),
            ),
          },
        );
        infbox.put("favoriteUploaded", true);
        setState(() {
          favoriteDone = true;
        });
      } catch (e) {}
    }
    if (bookmarkDone != true) {
      await databases.updateDocument(
        databaseId: "65bf585cdf62317b4d91",
        collectionId: "65bfa12aa542dc981ea8",
        documentId: user.$id,
        data: {
          "bookmark": jsonEncode(
            infbox.get("bookmark", defaultValue: []),
          ),
        },
      );
      infbox.put("bookmarkUploaded", true);
      setState(() {
        bookmarkDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: [
          !isLoogedIn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const LogIn());
                      },
                      label: const Text(
                        "LogIn",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                        ),
                      ),
                      icon: const Icon(Icons.login),
                    ),
                    const Text(
                      "You Need to login for more Features.\nFor Example, you can save your notes in\ncloud and access it from any places. Your Favorite and Book Mark can be uploaded to Cloud and download them after login.",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green,
                      child: GetX<AccountInfo>(
                        builder: (controller) => Text(
                          controller.name.value.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetX<AccountInfo>(
                          builder: (controller) => Text(
                            controller.name.value.length > 10
                                ? "${controller.name.value.substring(0, 10)}..."
                                : controller.name.value,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GetX<AccountInfo>(
                          builder: (controller) => Text(
                            controller.email.value.length > 20
                                ? "${controller.email.value.substring(0, 15)}...${controller.email.value.substring(controller.email.value.length - 9, controller.email.value.length)}"
                                : controller.email.value,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        GetX<AccountInfo>(
                          builder: (controller) => Text(
                            controller.uid.value,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: uploadAll,
                      child: Icon(
                        (favoriteDone && bookmarkDone && notesDone) == true
                            ? Icons.cloud_done
                            : Icons.cloud_upload,
                      ),
                    ),
                  ],
                ),
          Divider(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                expandedPosition[0] == 0
                    ? {expandedPosition[0] = -1, controller[0].reverse()}
                    : {expandedPosition[0] = 0, controller[0].forward()};
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 119, 119, 119),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  expandedPosition[0] == 0
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: SizeTransition(
              sizeFactor: sizeAnimation[0],
              axis: Axis.vertical,
              child: Column(
                children: notes.length == 0
                    ? [Center(child: Text("No Notes Found"))]
                    : notes,
              ),
            ),
          ),
          Divider(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                expandedPosition[1] == 1
                    ? {expandedPosition[1] = -1, controller[1].reverse()}
                    : {expandedPosition[1] = 1, controller[1].forward()};
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 119, 119, 119),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favorite",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  expandedPosition[1] == 1
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: SizeTransition(
              sizeFactor: sizeAnimation[1],
              axis: Axis.vertical,
              child: Column(
                children: favorite.length == 0
                    ? [Center(child: Text("No Favorite Found"))]
                    : favorite,
              ),
            ),
          ),
          Divider(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                expandedPosition[2] == 2
                    ? {expandedPosition[2] = -1, controller[2].reverse()}
                    : {expandedPosition[2] = 2, controller[2].forward()};
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 119, 119, 119),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book Mark",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  expandedPosition[2] == 2
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: SizeTransition(
              sizeFactor: sizeAnimation[2],
              axis: Axis.vertical,
              child: Column(
                children: bookmark.length == 0
                    ? [Center(child: Text("No Book Mark Found"))]
                    : bookmark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
