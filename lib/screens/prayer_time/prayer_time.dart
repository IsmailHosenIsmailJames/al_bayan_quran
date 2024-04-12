import 'package:al_bayan_quran/screens/prayer_time/prayer_time_controller.dart';
import 'package:al_bayan_quran/screens/prayer_time/select_location_manually.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  bool? isLocationEnabled;

  Future<bool> isLocationServiceEnabled() async {
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      isLocationEnabled;
    });
    return isLocationEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please give access of your",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Location ",
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(text: "So, we can calculate"),
                          TextSpan(
                            text: " Prayer Time",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.not_listed_location_rounded,
                  size: 150,
                  color: Color.fromARGB(199, 42, 149, 45),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.always ||
                      permission == LocationPermission.whileInUse) {
                    showModalBottomSheet(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    );
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.lowest);
                    final prayerTimeControllerGetx =
                        Get.put(PrayerTimeControllerGetx());

                    prayerTimeControllerGetx.latitude.value = position.latitude;
                    prayerTimeControllerGetx.longitude.value =
                        position.longitude;
                    prayerTimeControllerGetx.gotUserLocation.value = true;
                  } else if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.whileInUse ||
                        permission == LocationPermission.always) {
                    } else {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              "You have declined location access permission."),
                          content: const Text(
                              "If you don't want to provide location access, then you can choice your location manually."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancle"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.to(() => const SelectLocationManually());
                              },
                              child: const Text(
                                "Select Location Manually",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.location_pin),
                label: const Text(
                  "Enable Location",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text(
                'Or',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text:
                          "If you don't want to provide location access, then you can choice your location",
                    ),
                    TextSpan(
                      text: " manually. But it is not recomanded",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " if you want very ",
                    ),
                    TextSpan(
                      text: "accurate time of prayer.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Get.to(() => const SelectLocationManually());
                },
                icon: const Icon(Icons.edit_location_alt),
                label: const Text(
                  "Select Location Manually",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
