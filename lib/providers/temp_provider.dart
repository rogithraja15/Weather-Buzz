import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_buzz/providers/news_provider.dart';
import 'package:weather_buzz/services/weather_service.dart';

final temperatureUnitProvider = StateProvider<bool>((ref) {
  return true; // Default to Celsius
});

final forecastProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final isCelsius = ref.watch(temperatureUnitProvider);
  final areaName = ref.watch(areaNameProvider);
  final forecastData = await WeatherService().fetchFiveDayForecast(areaName);

  return forecastData.map((data) {
    final tempInCelsius = data['temperature'];
    final temp = isCelsius ? tempInCelsius : tempInCelsius * 9 / 5 + 32;
    return {
      'date': data['date'],
      'icon': data['icon'],
      'temperature': temp,
    };
  }).toList();
});
