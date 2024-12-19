import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class OthersPlatform extends StatelessWidget {
  const OthersPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Others Platforms".tr),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "We are happy to say now Al Quran Tafsir and Audio ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "app also support on ",
                        ),
                        TextSpan(
                          text: "Windows, Linux & Web. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "All these platform have both mobile view and desktop view depends on your app window width. If you have Computer, then Make sure that you have installed our Al Quran Tafsir & Audio application.",
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const Gap(50),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Get Windows installer here:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://github.com/IsmailHosenIsmailJames/al_bayan_quran/releases/tag/Windows"));
                    },
                    icon: const Icon(SimpleIcons.windows),
                    label: const Row(
                      children: [
                        Text(
                          "Windows",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.link),
                      ],
                    ),
                  ),
                  const Gap(20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Get Linux build here:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://github.com/IsmailHosenIsmailJames/al_bayan_quran/releases/tag/Linux"));
                    },
                    icon: const Icon(SimpleIcons.linux),
                    label: const Row(
                      children: [
                        Text(
                          "Linux",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.link),
                      ],
                    ),
                  ),
                  const Gap(20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Go to our Web App:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse("https://alquranwithaudio.web.app/"));
                    },
                    icon: const Icon(Icons.web),
                    label: const Row(
                      children: [
                        Text(
                          "Web",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.link),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
