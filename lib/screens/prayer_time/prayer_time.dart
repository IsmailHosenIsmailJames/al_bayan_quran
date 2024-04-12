import 'package:al_bayan_quran/screens/prayer_time/prayer_time_controller.dart';
import 'package:al_bayan_quran/screens/prayer_time/prayer_time_model.dart';
import 'package:al_bayan_quran/screens/prayer_time/select_location_manually.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  bool? isLocationEnabled;
  bool loadingLocation = false;
  bool haveInternetConnection = true;

  Future<bool> isLocationServiceEnabled() async {
    bool isEnabled = false;
    if (await Geolocator.isLocationServiceEnabled()) {}
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        isLocationEnabled = true;
      });
      isEnabled = true;
    }

    return isEnabled;
  }

  final controllerGetx = Get.put(PrayerTimeControllerGetx());

  Future<Position> getLocation() async {
    setState(() {
      loadingLocation = true;
    });
    Position position = await Geolocator.getCurrentPosition();
    final prayerTimeControllerGetx = Get.put(PrayerTimeControllerGetx());

    prayerTimeControllerGetx.latitude.value = position.latitude;
    prayerTimeControllerGetx.longitude.value = position.longitude;
    prayerTimeControllerGetx.gotUserLocation.value = true;
    final box = Hive.box("info");
    box.put("location", {"lat": position.latitude, "lon": position.longitude});
    setState(() {
      loadingLocation = false;
    });
    return position;
  }

  Future<void> getPrayerTimeData(
      int year, int month, double lat, double lon) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile))) {
      setState(() {
        haveInternetConnection = false;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const AlertDialog(),
      );
    } else {
      setState(() {
        haveInternetConnection = true;
      });
      String month1Safi =
          "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}";
      String month2Safi =
          "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}";
      String month1Hanafi =
          "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}&school=1";
      String month2Hanafi =
          "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}&school=1";
      http.Response dataMonth1Safi = await http.get(Uri.parse(month1Safi));

      final box = Hive.box("prayerTime");
      if (dataMonth1Safi.statusCode == 200) {
        box.put("$year/$month/safi", dataMonth1Safi.body);
        setState(() {
          safeiModel = PrayerTimeModel.fromJson(dataMonth1Safi.body);
        });
      }

      http.Response dataMonth2Safi = await http.get(Uri.parse(month2Safi));
      if (dataMonth2Safi.statusCode == 200) {
        box.put("$year/${month + 1}/safi", dataMonth2Safi.body);
      }

      http.Response dataMonth1Hanafi = await http.get(Uri.parse(month1Hanafi));
      if (dataMonth1Hanafi.statusCode == 200) {
        box.put("$year/$month/hanafi", dataMonth1Hanafi.body);
        setState(() {
          hanafiModel = PrayerTimeModel.fromJson(dataMonth1Hanafi.body);
        });
      }

      http.Response dataMonth2Hanafi = await http.get(Uri.parse(month2Hanafi));
      if (dataMonth2Hanafi.statusCode == 200) {
        box.put("$year/${month + 1}/hanafi", dataMonth2Hanafi.body);
      }
    }
  }

  PrayerTimeModel? safeiModel;
  PrayerTimeModel? hanafiModel;

  Future<void> getAdvancePrayerTimeOfAMonth(
      int year, int month, double lat, double lon) async {
    String month2Safi =
        "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}";
    String month2Hanafi =
        "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${controllerGetx.mahod}&school=1";
    http.Response dataMonth2Safi = await http.get(Uri.parse(month2Safi));
    final box = Hive.box("prayerTime");
    if (dataMonth2Safi.statusCode == 200) {
      box.put("$year/${month + 1}/safi", dataMonth2Safi.body);
    }
    http.Response dataMonth2Hanafi = await http.get(Uri.parse(month2Hanafi));
    if (dataMonth2Hanafi.statusCode == 200) {
      box.put("$year/${month + 1}/hanafi", dataMonth2Hanafi.body);
    }
  }

  @override
  void initState() {
    final boxinfo = Hive.box("info");
    final location = boxinfo.get("location", defaultValue: null);
    if (location != null) {
      controllerGetx.latitude.value = location['lat'];
      controllerGetx.longitude.value = location['lon'];
      controllerGetx.gotUserLocation.value = true;
      final boxPrayerTime = Hive.box("prayerTime");
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      final dataMonth1Safi =
          boxPrayerTime.get("$year/$month/safi", defaultValue: null);
      final dataMonth1Hanafi =
          boxPrayerTime.get("$year/$month/hanafi", defaultValue: null);
      if (dataMonth1Hanafi != null) {
        setState(() {
          hanafiModel = PrayerTimeModel.fromJson(dataMonth1Hanafi);
        });
      }
      if (dataMonth1Safi != null) {
        setState(() {
          safeiModel = PrayerTimeModel.fromJson(dataMonth1Safi);
        });
      }

      if (dataMonth1Hanafi == null || dataMonth1Safi == null) {
        getPrayerTimeData(year, month, location['lat'], location['lon']);
      }
      if (boxPrayerTime.get("$year/${month + 1}/safi", defaultValue: null) ==
              null ||
          boxPrayerTime.get("$year/${month + 1}/hanafi", defaultValue: null) ==
              null) {
        getAdvancePrayerTimeOfAMonth(
            year, month, location['lat'], location['lon']);
      }
      tryToGetLocationAutoAndCalculateDistance(
          location['lat'], location['lon']);
    }

    super.initState();
  }

  Future<void> tryToGetLocationAutoAndCalculateDistance(
      double p1Lat, double p1Lon) async {
    bool isLocationEnabled = await isLocationServiceEnabled();
    if (isLocationEnabled) {
      Position position = await getLocation();
      final distance = Geolocator.distanceBetween(
        p1Lat,
        p1Lon,
        position.latitude,
        position.longitude,
      );
      if (distance > 10) {
        final connectivityResult = await (Connectivity().checkConnectivity());

        if ((connectivityResult.contains(ConnectivityResult.ethernet) ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.mobile))) {
          getPrayerTimeData(DateTime.now().year, DateTime.now().month,
              position.latitude, position.longitude);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => controllerGetx.gotUserLocation.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    safeiModel == null
                        ? Center(
                            child: haveInternetConnection
                                ? const CircularProgressIndicator()
                                : const Text("Check internet connection."),
                          )
                        : const Center(
                            child: Text("Al Right"),
                          ),
                  ],
                )
              : Column(
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
                            Position position = await getLocation();
                            getPrayerTimeData(
                                DateTime.now().year,
                                DateTime.now().month,
                                position.latitude,
                                position.longitude);
                          } else if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission == LocationPermission.whileInUse ||
                                permission == LocationPermission.always) {
                              Position position = await getLocation();
                              getPrayerTimeData(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  position.latitude,
                                  position.longitude);
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
                                        Get.to(() =>
                                            const SelectLocationManually());
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
                        label: loadingLocation
                            ? const CircularProgressIndicator(
                                color: Colors.green,
                              )
                            : const Text(
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
      ),
    );
  }
}
