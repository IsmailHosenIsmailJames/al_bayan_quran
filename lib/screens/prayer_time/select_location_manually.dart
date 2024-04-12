import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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
      }

      final data = await http.get(Uri.parse(linkOfLocationOfAllCitiesFile));
      setState(() {
        listOfCities = json.decode(data.body)['cities'];
      });
      box.put("cities", listOfCities);
    } else {
      setState(() {
        listOfCities = cities;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfCities == null
          ? Center(
              child: internetConnectionAvailable
                  ? const CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : const Text("No internet conection available"),
            )
          : Center(
              child: Text("Go List Of ${listOfCities!.length}"),
            ),
    );
  }
}
