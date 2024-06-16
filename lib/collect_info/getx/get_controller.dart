import 'package:get/get.dart';

class InfoController extends GetxController {
  RxString translationLanguage = "".obs;
  RxString bookIDTranslation = "-1".obs;
  RxInt bookNameIndex = (-1).obs;
  RxInt tafseerIndex = (-1).obs;
  RxString tafseerID = "-1".obs;
  RxString tafseerLanguage = "null".obs;
  RxInt tafseerBookIndex = (-1).obs;
  RxString tafseerBookID = "-1".obs;
  RxInt recitationIndex = (-1).obs;
  RxString recitationName = "-1".obs;
  RxString tafsirBookName = "null".obs;
  RxString translationBookName = "null".obs;
  RxBool isPreviousEnaviled = false.obs;
}
