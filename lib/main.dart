import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'src/collect_info/getx/get_controller.dart';
import 'src/collect_info/init.dart';
import 'src/theme/theme_controller.dart';
import 'package:appwrite/appwrite.dart';

import 'src/translations/language_controller.dart';
import 'src/translations/map_of_translation.dart';

import 'dart:ui' as ui;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('albayanquran')
      .setSelfSigned(status: true);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter("al_bayan_quran");
  await Hive.openBox("info");
  await Hive.openBox("data");
  await Hive.openBox("accountInfo");
  await Hive.openBox("notes");
  await Hive.openBox("quran");
  await Hive.openBox("translation");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Quran',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade800,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      defaultTransition: Transition.leftToRight,
      themeMode: ThemeMode.system,
      locale: Get.deviceLocale,
      fallbackLocale: const ui.Locale("en"),
      translationsKeys: AppTranslation.translationsKeys,
      onInit: () async {
        final appTheme = Get.put(AppThemeData());
        final infoController = Get.put(InfoController());

        final languageController = Get.put(LanguageController());
        final prefBox = Hive.box("info");
        String? languageCode = prefBox.get("app_lan", defaultValue: null);
        if (languageCode == null) {
          languageCode ??= Get.locale?.languageCode;
          infoController.appLanCode.value = languageCode ?? '';
          languageController.changeLanguage = languageCode ?? 'en';
        } else {
          languageController.changeLanguage = languageCode;
          infoController.appLanCode.value = languageCode;
        }
        appTheme.initTheme();
      },
      home: const StartUpPage(),
    );
  }
}

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  @override
  Widget build(BuildContext context) {
    return const InIt();
  }
}
