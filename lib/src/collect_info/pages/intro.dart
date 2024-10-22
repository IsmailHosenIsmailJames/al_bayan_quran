import 'package:flutter/material.dart';
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
                  "assets/img/QuranLogo.jpg",
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          child: Text(
            "All in one Al Quran App with Translation  in 69 languages & 180+ translation books, Tafsir in 6 languages with 30  tafsir books 35+ & Quran reciter's recitation",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Data collected from :"),
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse("https://quran.com/"),
                      mode: LaunchMode.externalApplication);
                },
                child: Text("quran.com"),
              ),
              Text("and"),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("https://everyayah.com/"),
                        mode: LaunchMode.externalApplication);
                  },
                  child: Text("everyayah.com")),
            ],
          ),
        ),
      ],
    );
  }
}
