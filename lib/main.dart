import 'package:flutter/material.dart';
import 'package:weather_app/weatherapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      home: const Weatherapp(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}