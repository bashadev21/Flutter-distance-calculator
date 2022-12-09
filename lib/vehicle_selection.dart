import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
// ignore: library_prefixes

class VehiclSelectioView extends StatefulWidget {
  const VehiclSelectioView({super.key});

  @override
  State<VehiclSelectioView> createState() => _VehiclSelectioViewState();
}

class _VehiclSelectioViewState extends State<VehiclSelectioView> {
  var type = '';
  var pickuplat;
  var pickuplang;
  var droplat;
  var droplang;
  var isPickSelected = true;
  var showSugg = false;
  var total = 0;
  var distance;
  var farePrice;
  var minPrice;
  var maxPrice;

  final TextEditingController firstLocation = TextEditingController();
  final TextEditingController secondLocation = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgrounColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                type = '';
                firstLocation.clear();
                secondLocation.clear();
                minPrice = null;
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        centerTitle: true,
        title:
            const Text('Choose vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fareData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        type = fareData[index]['type'].toString();
                        if (type.isNotEmpty &&
                            firstLocation.text.isNotEmpty &&
                            secondLocation.text.isNotEmpty) {
                          calculateFarePrice();
                        }
                      });
                    },
                    child: Card(
                      color: type == fareData[index]['type']
                          ? Colors.teal
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          fareData[index]['type'].toString(),
                          style: TextStyle(
                              color: type == fareData[index]['type']
                                  ? Colors.white
                                  : Colors.teal,
                              fontSize:
                                  type == fareData[index]['type'] ? 24 : 19,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            TextField(
              cursorColor: themeColor,
              controller: firstLocation,
              onTap: () {
                isPickSelected = true;
              },
              onChanged: (value) {
                showSugg = true;
                isPickSelected = true;

                getLatLangbyLocation(firstLocation.text, 'pickup');

                // if (distanceCon.text.isNotEmpty && hourCon.text.isNotEmpty) {
                //   calculate();
                // }
                setState(() {});
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Pickup Location",
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: themeColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: themeColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              cursorColor: themeColor,
              controller: secondLocation,
              onTap: () {
                isPickSelected = false;
              },
              onChanged: (value) {
                showSugg = true;
                isPickSelected = false;
                getLatLangbyLocation(secondLocation.text, 'drop');
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Drop Location",
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: themeColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: themeColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (showSugg)
              Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: _placeList.isEmpty
                    ? const Center(
                        child: Text('No location found'),
                      )
                    : ListView.builder(
                        itemCount: _placeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () async {
                              var addresses = await Geocoder.local
                                  .findAddressesFromQuery(
                                      _placeList[index]['description']);
                              if (isPickSelected) {
                                setState(() {
                                  pickuplat =
                                      addresses.first.coordinates.latitude;
                                  pickuplang =
                                      addresses.first.coordinates.longitude;
                                  firstLocation.text = _placeList[index]
                                          ['description']
                                      .toString();
                                  FocusScope.of(context).unfocus();
                                  showSugg = false;
                                });
                              } else {
                                setState(() {
                                  droplat =
                                      addresses.first.coordinates.latitude;
                                  droplang =
                                      addresses.first.coordinates.longitude;
                                  secondLocation.text = _placeList[index]
                                          ['description']
                                      .toString();
                                  FocusScope.of(context).unfocus();
                                  showSugg = false;
                                });
                              }
                            },
                            title: Text(
                                _placeList[index]['description'].toString()),
                          );
                        },
                      ),
              ),
            const SizedBox(
              height: 15,
            ),
            if (type != '' &&
                firstLocation.text.isNotEmpty &&
                secondLocation.text.isNotEmpty)
              Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          calculateFarePrice();
                        },
                        child: const Text(
                          "CALCULATE",
                          style: TextStyle(letterSpacing: 1.5),
                        )),
                  )),
                ],
              ),
            const SizedBox(
              height: 15,
            ),
            if (minPrice != null)
              Text(
                  'Total Distance : ${distance.toDouble().toStringAsFixed(1)} Km',
                  style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(
              height: 15,
            ),
            if (minPrice != null)
              Text('Fare Price : $minPrice - $maxPrice',
                  style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _placeList = [];
  void getLatLangbyLocation(String input, type) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$GEOAPIKEY';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
        print(_placeList.toString());
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  calculateFarePrice() {
    showSugg = false;
    distance =
        getDistanceFromLatLonInKm(pickuplat, pickuplang, droplat, droplang);
    var splitDouble = distance.toDouble().toStringAsFixed(1);

    var baseFarePrice = type == "Auto"
        ? fareData[0]['base_fare']
        : type == "Car"
            ? fareData[1]['base_fare']
            : fareData[2]['base_fare'];
    farePrice = double.parse(splitDouble.toString()) *
        double.parse(baseFarePrice.toString());
    var variation = type == 'Auto'
        ? fareData[0]['variation']
        : type == 'Car'
            ? fareData[1]['variation']
            : fareData[2]['variation'];
    var variationPrice = farePrice / 100 * variation;
    minPrice = farePrice - variationPrice;
    maxPrice = variationPrice + farePrice;
    setState(() {});
  }
}
