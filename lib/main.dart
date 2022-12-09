import 'package:distancecalcy/vehicle_selection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fare Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VehiclSelectioView(),
    );
  }
}
