import 'package:al_bayan_quran/screens/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/account_info/account_info.dart';
import '../../auth/login/login.dart';
import '../../theme/theme_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: Center(
        child: !isLoogedIn
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "You Need to login for more Features.\nFor Example, you can save your notes in\ncloud and access it from any places.",
                      style: TextStyle(fontSize: 10),
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
      ),
    );
  }
}
