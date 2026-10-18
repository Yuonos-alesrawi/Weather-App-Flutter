import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additionalinfoitem.dart';
import 'package:weather_app/hourlyforcastitem.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class Weatherapp extends StatefulWidget {
  const Weatherapp({super.key});

  @override
  State<Weatherapp> createState() => _WeatherappState();
}

class _WeatherappState extends State<Weatherapp> {
  Future<Position> getCurrentLocation() async {
    bool serviceenabled;
    LocationPermission permission;

    serviceenabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceenabled) {
      Geolocator.openLocationSettings();
      return Future.error('Please Turn on location service');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return Future.error('Can\'t access your location');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permission is completely rejected!\nIt must be activated from the settings',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, dynamic>> getcurrentweather() async {
    try {
      Position pos = await getCurrentLocation();
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${pos.latitude}&lon=${pos.longitude}&APPID=$openweatherAPIkey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather app',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getcurrentweather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currenttemp = kelvinToCelsius(data['list'][0]['main']['temp']);
          final currentwether = data['list'][0]['weather'][0]['main']
              .toString();
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windspeed = data['list'][0]['wind']['speed'];
          final time = DateTime.parse(data['list'][0]['dt_txt']);
          final h = time.hour;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "${currenttemp.toStringAsFixed(2)}°C",
                                  style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentwether == 'Clouds' ||
                                          currentwether == 'Rain'
                                      ? Icons.cloud
                                      : h >= 21 || h < 6
                                      ? Icons.nightlight_round_outlined
                                      : Icons.sunny,
                                  size: 50,
                                ),
                                Text(
                                  currentwether,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final t = DateTime.parse(
                        data['list'][index + 1]['dt_txt'],
                      );
                      final weatherforcast =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hour = t.hour;
                      IconData iconData;
                      final forecast = weatherforcast.toString();
                      if (forecast == 'Clouds' || forecast == 'Rain') {
                        iconData = Icons.cloud;
                      } else if (hour >= 18 || hour < 6) {
                        iconData = Icons.nightlight_round_outlined;
                      } else {
                        iconData = Icons.sunny;
                      }
                      return HourlyForcastItem(
                        icon: iconData,
                        time: DateFormat.j().format(t),
                        tp: kelvinToCelsius(
                          data['list'][index + 1]['main']['temp'],
                        ).toStringAsFixed(2),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '$humidity',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '$windspeed',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'pressure',
                        value: '$pressure',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
