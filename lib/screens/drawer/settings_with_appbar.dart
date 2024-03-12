import 'package:flutter/material.dart';

import '../../theme/theme_icon_button.dart';
import '../settings/settings.dart';

class SettingsWithAppbar extends StatelessWidget {
  const SettingsWithAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: themeIconButton,
          ),
        ],
      ),
      body: const Settings(
        showNavigator: false,
      ),
    );
  }
}
