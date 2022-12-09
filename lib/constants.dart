import 'package:flutter/material.dart';
import 'dart:math' as Math;

const backgrounColor = Color.fromARGB(136, 61, 55, 55);
const themeColor = Colors.teal;
const GEOAPIKEY = 'AIzaSyBpo7cXvx_bI4pRmCm0yI5nRTMSguZektI';

var fareData = [
  {
    "type": "Auto",
    "base_fare": 20,
    "fare_one_km": 12,
    "variation": 5,
  },
  {
    "type": "Car",
    "base_fare": 50,
    "fare_one_km": 22,
    "variation": 7,
  },
  {
    "type": "Truck",
    "base_fare": 80,
    "fare_one_km": 25,
    "variation": 10,
  },
];

//HaverSine formula
double? getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) *
          Math.cos(deg2rad(lat2)) *
          Math.sin(dLon / 2) *
          Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

double deg2rad(deg) {
  return deg * (Math.pi / 180);
}
