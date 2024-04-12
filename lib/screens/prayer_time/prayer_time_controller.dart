import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class PrayerTimeControllerGetx extends GetxController {
  RxBool gotUserLocation = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
}
