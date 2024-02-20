import 'package:al_bayan_quran/screens/home_desktop.dart';
import 'package:al_bayan_quran/screens/home_mobile.dart';
import 'package:flutter/widgets.dart';

class HomeResponsiveLayout extends StatelessWidget {
  const HomeResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) {
          return const HomeDesktop();
        } else {
          return const HomeMobile();
        }
      },
    );
  }
}
