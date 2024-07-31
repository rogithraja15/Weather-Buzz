import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/weather.dart';
import 'package:weather_buzz/services/news_service.dart';
import 'package:weather_buzz/utils/api_endpoints.dart';

final areaNameProvider = StateProvider<String>((ref) => 'Chennai');

final weatherProvider = FutureProvider<Weather>((ref) async {
  final areaName = ref.watch(areaNameProvider);
  final weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  final weather = await weatherFactory.currentWeatherByCityName(areaName);
  return weather;
});

final newsCategoryProvider = StateProvider<String>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.when(
    data: (weather) {
      final tempInCelsius = weather.temperature?.celsius ?? 0;

      if (tempInCelsius <= 10) {
        return 'depressing'; // Cold weather
      } else if (tempInCelsius >= 30) {
        return 'fear'; // Hot weather
      } else {
        return 'happiness'; // Cool weather
      }
    },
    loading: () => 'happiness',
    error: (error, stack) => 'happiness',
  );
});

final newsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final category = ref.watch(newsCategoryProvider);

  return NewsService().fetchAllNews(category);
});
