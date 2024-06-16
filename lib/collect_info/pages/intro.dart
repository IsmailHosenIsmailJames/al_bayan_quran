import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(500),
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(500),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(500),
                  bottomRight: Radius.circular(500),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(50),
                height: 100,
                width: 100,
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage(
                    "assets/img/QuranLogo.jpg",
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(
              0.87,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: const Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "All in one",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: " Al Quran ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(
                    text: "App with ",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: "Translation ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " in ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                      text: "69",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: " languages ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: "&",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: " 180+ ",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "translation books,",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: " Tefsir ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "in ",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: "6 ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "languages",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: " with",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: " 30 ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " tafsir books",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: " 35+ ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Quran reciter's",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: " recitation",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
