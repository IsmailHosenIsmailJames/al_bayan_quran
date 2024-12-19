import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.6),
                  spreadRadius: 10,
                  blurRadius: 40,
                ),
              ],
              image: const DecorationImage(
                image: AssetImage(
                  "assets/img/QuranLogo.png",
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          child: Text(
            "intro_text".tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Data collected from :"),
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse("https://quran.com/"),
                      mode: LaunchMode.externalApplication);
                },
                child: const Text("quran.com"),
              ),
              const Text("and"),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("https://everyayah.com/"),
                        mode: LaunchMode.externalApplication);
                  },
                  child: const Text("everyayah.com")),
            ],
          ),
        ),
      ],
    );
  }
}
