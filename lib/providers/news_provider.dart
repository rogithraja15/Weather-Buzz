import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_buzz/providers/weather_provider.dart';
import 'package:weather_buzz/services/news_service.dart';

final newsCategoryProvider = StateProvider<String>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.when(
    data: (weather) {
      final tempInCelsius = weather.temperature?.celsius ?? 0;

      if (tempInCelsius <= 10) {
        return 'sadness'; // Cold weather
      } else if (tempInCelsius >= 30) {
        return 'fear'; // Hot weather
      } else {
        return 'joy'; // Cool weather
      }
    },
    loading: () => 'joy',
    error: (error, stack) => '',
  );
});

final newsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final category = ref.watch(newsCategoryProvider);

  final newsService = NewsService();
  final newsItems = await newsService.fetchAllNews(category);

  final newsWithEmotion = await Future.wait(newsItems.map((newsItem) async {
    final emotion = await newsService.analyzeEmotion(newsItem['title']);
    final label = emotion['label'] ?? 'unknown';
    final score = emotion['score'] ?? 0.0;

    return {
      ...newsItem,
      'emotion': label,
      'score': score,
    };
  }));

  return newsWithEmotion.where((newsItem) {
    final emotion = newsItem['emotion'];
    return emotion == category;
  }).toList();
});
