import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationHelper {
  static Future<Position?> getCurrentLocation() async {
    Position? position;

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // Location service is not enabled
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return null; // Location permission denied forever
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null; // Location permission denied again
      }
    }
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error fetching location: $e");
    }

    return position;
  }
  static Future<Map<String, dynamic>?> fetchWeatherData(double lat, double lon, String apiKey) async {
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
    
    final response = await http.get(
      Uri.parse('$apiUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      return weatherData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
