import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SelectLocationManually extends StatefulWidget {
  const SelectLocationManually({super.key});

  @override
  State<SelectLocationManually> createState() => _SelectLocationManuallyState();
}

class _SelectLocationManuallyState extends State<SelectLocationManually> {
  String linkOfLocationOfAllCitiesFile =
      "https://firebasestorage.googleapis.com/v0/b/tpiprogrammingclub.appspot.com/o/quran%2Flistofcities.json?alt=media&token=dcaff543-6f04-4772-a6fb-21c7de6ed69e";

  Future<void> getListOfCities() async {
    final box = await Hive.openBox("listOfCities");
    List? cities = box.get("cities", defaultValue: null);
    if (cities == null) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult.contains(ConnectivityResult.ethernet) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile))) {
        setState(() {
          internetConnectionAvailable = false;
        });
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
                  getListOfCities();
                },
                label: const Text("Retry"),
                icon: const Icon(Icons.restore),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          internetConnectionAvailable = internetConnectionAvailable;
        });
        final data = await http.get(Uri.parse(linkOfLocationOfAllCitiesFile));
        setState(() {
          listOfCities = json.decode(data.body)['cities'];
          machedCitiesList = json.decode(data.body)['cities'];
        });
        box.put("cities", listOfCities);
      }
    } else {
      setState(() {
        listOfCities = cities;
        machedCitiesList = cities;
      });
    }
  }

  List? listOfCities;
  bool internetConnectionAvailable = true;
  @override
  void initState() {
    getListOfCities();
    super.initState();
  }

  List machedCitiesList = [];

  Future<void> searchOnCities(String s) async {
    setState(() {
      machedCitiesList = listOfCities!
          .where((element) =>
              ("${element[0]}, ${element[3]}").toLowerCase().contains(s))
          .toList();
    });
  }

  String selectedCityNameWithCountry = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedCityNameWithCountry.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                for (int i = 0; i < listOfCities!.length; i++) {
                  if (listOfCities![i][0] + listOfCities![i][3] ==
                      selectedCityNameWithCountry) {
                    Get.back(result: {
                      "lat": listOfCities![i][1],
                      "lon": listOfCities![i][2],
                    });
                  }
                }
              },
              label: const Row(
                children: [
                  Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward,
                  ),
                ],
              ),
            ),
      appBar: AppBar(
        backgroundColor: Colors.green.withOpacity(0.4),
        automaticallyImplyLeading: false,
        title: CupertinoSearchTextField(
          placeholder: "Search your city...",
          onChanged: (value) {
            searchOnCities(value.toLowerCase().trim());
          },
          style: const TextStyle(),
        ),
      ),
      body: listOfCities == null
          ? Center(
              child: internetConnectionAvailable
                  ? const CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : const Text("No internet conection available"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: machedCitiesList.length,
              itemBuilder: (context, index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: selectedCityNameWithCountry ==
                            machedCitiesList[index][0] +
                                machedCitiesList[index][3]
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCityNameWithCountry = machedCitiesList[index][0] +
                          machedCitiesList[index][3];
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${machedCitiesList[index][0]}, ${machedCitiesList[index][3]}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      if (selectedCityNameWithCountry ==
                          machedCitiesList[index][0] +
                              machedCitiesList[index][3])
                        const Icon(
                          Icons.done_rounded,
                          color: Colors.green,
                          size: 26,
                        )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
