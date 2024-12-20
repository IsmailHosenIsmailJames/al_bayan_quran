import 'package:al_quran/src/collect_info/collect_info_mobile.dart';
import 'package:flutter/widgets.dart';

import 'collect_info_desktop.dart';

class CollectInfoResponsive extends StatelessWidget {
  final int pageNumber;
  const CollectInfoResponsive({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) {
          return CollectInfoDesktop(pageNumber: pageNumber);
        } else {
          return CollectInfoMobile(pageNumber: pageNumber);
        }
      },
    );
  }
}
