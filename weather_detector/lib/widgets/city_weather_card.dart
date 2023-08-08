import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CityWeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  CityWeatherCard(this.weatherData);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(241, 255, 217, 3),
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weatherData['name']}',
              style: GoogleFonts.lato(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${weatherData['main']['temp'].toInt()} °C',
              style: GoogleFonts.lato(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Weather: ${weatherData['weather'][0]['description']}',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
