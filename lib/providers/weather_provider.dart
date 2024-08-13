import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/weather.dart';

import '../utils/api_endpoints.env';

final areaNameProvider = StateProvider<String>((ref) => 'Chennai');

final weatherProvider = FutureProvider<Weather>((ref) async {
  final areaName = ref.watch(areaNameProvider);
  final weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  final weather = await weatherFactory.currentWeatherByCityName(areaName);
  return weather;
});
