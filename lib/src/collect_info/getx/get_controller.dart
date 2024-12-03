import 'package:al_quran/src/core/recitation_info/recitation_info_model.dart';
import 'package:get/get.dart';

class InfoController extends GetxController {
  RxString appLanCode = ''.obs;
  RxString translationLanguage = "".obs;
  RxString bookIDTranslation = "-1".obs;
  RxInt bookNameIndex = (-1).obs;
  RxInt tafseerIndex = (-1).obs;
  RxString tafseerID = "-1".obs;
  RxString tafseerLanguage = "null".obs;
  RxInt tafseerBookIndex = (-1).obs;
  RxString tafseerBookID = "-1".obs;
  Rx<RecitationInfoModel> recitationIndex = Rx(RecitationInfoModel());
  RxString recitationName = "-1".obs;
  RxString tafsirBookName = "null".obs;
  RxString translationBookName = "null".obs;
}
