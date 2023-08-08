import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Map<String, dynamic>? currentLocationWeatherData;
  CurrentWeatherCard(this.currentLocationWeatherData);

  String getWindSpeed() {
    if (currentLocationWeatherData != null &&
        currentLocationWeatherData!['wind'] != null) {
      double windSpeed =
          currentLocationWeatherData!['wind']['speed'].toDouble();
      return '$windSpeed m/s'; // Format wind speed
    }
    return 'N/A';
  }
  String getHumidity() {
    if (currentLocationWeatherData != null &&
        currentLocationWeatherData!['main'] != null) {
      int humidity = currentLocationWeatherData!['main']['humidity'];
      return '$humidity %'; // Format humidity
    }
    return 'N/A';
  }

  String getRain() {
    if (currentLocationWeatherData != null &&
        currentLocationWeatherData!['rain'] != null) {
      double rain = currentLocationWeatherData!['rain']['1h'].toDouble();
      return '$rain mm/h'; // Format rain
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            // Background Image
            Image.network(
              'https://img.freepik.com/premium-psd/sunny-rainy-cloudy-day-weather-forecast-icon-illustration_47987-10695.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              top: 45,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Name
                  Text(
                    '${currentLocationWeatherData!['name']}',
                    style: GoogleFonts.lato(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Date and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('h:mm a')
                            .format(DateTime.now()), // Display time
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        DateFormat('EEEE')
                            .format(DateTime.now()),
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        DateFormat('d MMMM yyyy')
                            .format(DateTime.now()),
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Current Temperature
            Positioned(
              top: 45,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currentLocationWeatherData!['main']['temp'].toStringAsFixed(0)} °C',
                    style: GoogleFonts.lato(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Additional Weather Information (Wind, Humidity, Rain)
            Positioned(
              bottom: 14,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wind Information
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(Icons.air),
                          Text('Wind'),
                          Text(
                            getWindSpeed(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Humidity Information
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(Icons.opacity),
                          Text('Humidity'),
                          Text(
                            getHumidity(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Rain Information
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(Icons.cloud),
                          Text('Rain'),
                          Text(
                            getRain(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
