import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/city_weather_card.dart';
import '../widgets/current_weather_card.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey =
      '7d66b39442f93cd35e52fe3a2c9d5f84'; // Replace with your API key
  String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
  List<Map<String, dynamic>> citiesWeatherData = [
  ];
  Map<String, dynamic>? currentLocationWeatherData;
  Position? _currentPosition;
  List<String> cities = [
    'New York',
    'Singapore',
    'Mumbai',
    'Delhi',
    'Sydney',
    'Melbourne',
  ];
  final String lastViewedLocationKey = 'lastViewedLocation';

  Future<void> _fetchWeatherDataForCurrentLocation() async {
    if (_currentPosition != null) {
      final response = await http.get(
        Uri.parse(
            '$apiUrl?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&appid=$apiKey&units=metric'),
      );
      if (response.statusCode == 200) {
        setState(() {
          currentLocationWeatherData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load current location weather data');
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        lastViewedLocationKey, json.encode(currentLocationWeatherData));
  }

  Future<void> _loadLastViewedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLocationJson = prefs.getString(lastViewedLocationKey);
    if (lastLocationJson != null) {
      setState(() {
        currentLocationWeatherData = json.decode(lastLocationJson);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLastViewedLocation();
    _getCurrentLocation();
    _fetchWeatherDataForCities();
  }

  Future<void> _fetchWeatherDataForCities() async {
    for (String city in cities) {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$city&appid=$apiKey&units=metric'),
      );
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        citiesWeatherData.add(weatherData);
      } else {
        throw Exception('Failed to load weather data for $city');
      }
    }
    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location service is not enabled, prompt the user to enable it.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
  
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _fetchWeatherDataForCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Main Card Section
          currentLocationWeatherData == null
              ? CircularProgressIndicator()
              : CurrentWeatherCard(currentLocationWeatherData),

          // Cities List Section
          Expanded(
            flex: 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: citiesWeatherData.length,
              itemBuilder: (context, index) {
                final weatherData = citiesWeatherData[index];
                return CityWeatherCard(weatherData);
              },
            ),
          ),
        ],
      ),
    );
  }
}
