import 'package:al_quran/src/core/recitation_info/recitation_info_model.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  RxInt currentIndex = (-1).obs;
  RxBool isPlaying = false.obs;
  RxInt progress = 0.obs;
  RxInt duration = 0.obs;
  RxDouble speed = 1.0.obs;
  RxBool isStreamRegistered = false.obs;
  Rx<RecitationInfoModel> currentRecitation = Rx(RecitationInfoModel());
}
