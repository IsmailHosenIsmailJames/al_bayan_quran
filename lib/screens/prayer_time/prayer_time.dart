import 'package:al_bayan_quran/screens/drawer/drawer.dart';
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
  int day = DateTime.now().day;

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

  final prayerTimeControllerGetx = Get.put(PrayerTimeControllerGetx());

  Future<Position> getLocation() async {
    setState(() {
      loadingLocation = true;
    });
    Position position = await Geolocator.getCurrentPosition();

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

  Future<void> getPrayerTimeData(int year, int month, double lat, double lon,
      {bool showAleartDialog = true}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile))) {
      setState(() {
        haveInternetConnection = false;
      });
      if (showAleartDialog) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Need internet connection"),
            content: const Text(
                "Need to download required data for the first time."),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text("OK"),
                icon: const Icon(
                  Icons.close,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  getPrayerTimeData(year, month, lat, lon);
                },
                label: const Text("Retry"),
                icon: const Icon(Icons.restore),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        haveInternetConnection = true;
      });
      String month1Safi =
          "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}";
      String month2Safi =
          "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}";
      String month1Hanafi =
          "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}&school=1";
      String month2Hanafi =
          "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}&school=1";
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
  bool isSafi = true;

  Future<void> getAdvancePrayerTimeOfAMonth(
      int year, int month, double lat, double lon) async {
    String month2Safi =
        "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}";
    String month2Hanafi =
        "https://api.aladhan.com/v1/calendar/$year/${month + 1}?latitude=$lat&longitude=$lon&method=${prayerTimeControllerGetx.mahod}&school=1";
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
      prayerTimeControllerGetx.latitude.value = location['lat'];
      prayerTimeControllerGetx.longitude.value = location['lon'];
      prayerTimeControllerGetx.gotUserLocation.value = true;
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

      if (boxinfo.get("school", defaultValue: null) != null) {
        setState(() {
          isSafi = boxinfo.get("school") == "0";
        });
      }

      if (dataMonth1Hanafi == null || dataMonth1Safi == null) {
        getPrayerTimeData(year, month, location['lat'], location['lon'],
            showAleartDialog: false);
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
          final box = Hive.box("info");
          box.put("location",
              {"lat": position.latitude, "lon": position.longitude});

          getPrayerTimeData(DateTime.now().year, DateTime.now().month,
              position.latitude, position.longitude);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.location_on_sharp,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              safeiModel!.data[DateTime.now().day].meta.timezone
                  .replaceAll("/", ", "),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: settings to be added with full functionality
            },
            tooltip: "Prayer Time Settings",
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => prayerTimeControllerGetx.gotUserLocation.value
              ? safeiModel == null
                  ? Center(
                      child: haveInternetConnection
                          ? const CircularProgressIndicator()
                          : const Text("Check internet connection."),
                    )
                  : ListView(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height:
                                  MediaQuery.of(context).size.width / 2 - 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(255, 168, 175, 76)
                                        .withOpacity(0.01),
                                    Colors.orange.withOpacity(0.5),
                                  ],
                                ),
                                image: const DecorationImage(
                                  alignment: Alignment.bottomRight,
                                  opacity: 0.5,
                                  image: AssetImage(
                                    "assets/img/Mosque-2.png",
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Now time is",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(getNowSalahName(
                                      safeiModel!.data[day - 1].timings))
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height:
                                  MediaQuery.of(context).size.width / 2 - 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green.withOpacity(0.01),
                                    Colors.green.withOpacity(0.3),
                                  ],
                                ),
                                image: const DecorationImage(
                                  alignment: Alignment.bottomRight,
                                  opacity: 0.5,
                                  image: AssetImage(
                                    "assets/img/Mosque-2.png",
                                  ),
                                ),
                              ),
                              child: const Column(children: [
                                Text(
                                  "12:00",
                                  style: TextStyle(fontSize: 80),
                                )
                              ]),
                            ),
                          ],
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
                          final result = await Get.to(
                              () => const SelectLocationManually());
                          result["lat"] = double.parse(result["lat"]);
                          result["lon"] = double.parse(result["lon"]);
                          prayerTimeControllerGetx.latitude.value =
                              result['lat'];
                          prayerTimeControllerGetx.longitude.value =
                              result["lon"];
                          prayerTimeControllerGetx.gotUserLocation.value = true;
                          final box = Hive.box("info");
                          box.put("location",
                              {"lat": result["lat"], "lon": result["lon"]});
                          getPrayerTimeData(
                            DateTime.now().year,
                            DateTime.now().month,
                            result['lat'],
                            result['lon'],
                          );
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

  String getNowSalahName(Timings timings) {
    List<String> salahName = [
      "fajr",
      "dhuhr",
      "asr",
      "sunset",
      "maghrib",
      "isha",
      "midnight",
      "imsak",
      "sunrise",
    ];
    int indexOfName = getIndexOfNowPrayerTime(timings);
    print(indexOfName);
    print(salahName[indexOfName]);
    return "xyz";
  }

  int getIndexOfNowPrayerTime(Timings timings) {
    List<String> listOfTiming = [
      timings.sunrise,
      timings.fajr,
      timings.dhuhr,
      timings.asr,
      timings.sunset,
      timings.maghrib,
      timings.isha,
      timings.midnight,
      timings.imsak,
    ];
    List<int> listOfSalahDateTime = [];
    for (int i = 0; i < listOfTiming.length; i++) {
      listOfSalahDateTime.add(splitStringToDateTime(listOfTiming[i]));
    }
    int now = DateTime.now().hour * 60 * DateTime.now().minute;
    listOfSalahDateTime.add(now);
    listOfSalahDateTime.sort();
    int index = listOfSalahDateTime.indexOf(now);
    if (index + 1 == listOfSalahDateTime.length) {
      return index - 1;
    } else if (listOfSalahDateTime[index + 1] == now) {
      return index + 1;
    } else {
      return index;
    }
  }

  int splitStringToDateTime(String s) {
    List<String> hourAndMin = s.split("(")[0].trim().split(":");
    return int.parse(hourAndMin[0]) * 60 + int.parse(hourAndMin[1]);
  }
}
