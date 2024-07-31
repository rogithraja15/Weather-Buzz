import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '170438a437f9912cf59796bec5ad8d9f';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<List<Map<String, dynamic>>> fetchFiveDayForecast(String city) async {
    final response =
        await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> forecasts = [];

      for (var entry in data['list']) {
        final date = DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000);
        final temp = entry['main']['temp'] - 273.15;
        final description = entry['weather'][0]['description'];
        final icon = entry['weather'][0]['icon'];

        forecasts.add({
          'date': date,
          'temperature': temp,
          'description': description,
          'icon': icon,
        });
      }
      return forecasts;
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
