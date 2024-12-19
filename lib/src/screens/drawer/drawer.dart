import 'package:al_quran/src/auth/account_info/account_info.dart';
import 'package:al_quran/src/auth/login/login.dart';
import 'package:al_quran/src/collect_info/init.dart';
import 'package:al_quran/src/screens/drawer/settings_with_appbar.dart';
import 'package:al_quran/src/screens/favorite_bookmark_notes/book_mark.dart';
import 'package:al_quran/src/screens/favorite_bookmark_notes/notes_v.dart';
import 'package:al_quran/src/screens/home_mobile.dart';
import 'package:al_quran/src/theme/theme_controller.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/theme_icon_button.dart';
import '../favorite_bookmark_notes/favorite.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isLoggedIn
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(() => const LogIn());
                              },
                              label: Text(
                                "LogIn".tr,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(
                                Icons.login,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                "loginReason".tr,
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          ],
                        ),
                      )
                    : Row(
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
                        ],
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: "Close Drawer",
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                    themeIconButton,
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Get.offAll(() => const HomeMobile());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.home_rounded,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Home".tr),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");

              Get.to(
                () => const Favorite(),
              );
            },
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Favorite".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");

              Get.to(() => const BookMark());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.bookmark_added,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Book Mark".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox('quran');
              await Hive.openBox("translation");
              await Hive.openBox("notes");
              Get.to(() => const NotesView());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.note_add,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Notes".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              await Hive.openBox("translation");
              await Hive.openBox(quranScriptType);

              Get.to(() => const SettingsWithAppbar());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Settings".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(
                  "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"));
            },
            child: Row(
              children: [
                const Icon(
                  Icons.privacy_tip,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text("Privacy Policy".tr)
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (isLoggedIn)
            TextButton(
              onPressed: () async {
                Client client = Client()
                    .setEndpoint("https://cloud.appwrite.io/v1")
                    .setProject("albayanquran");
                Account account = Account(client);
                await account.deleteSession(sessionId: 'current');
                setState(() {
                  isLoggedIn = false;
                });
                Get.offAll(
                  () => const InIt(),
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Log Out")
                ],
              ),
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
