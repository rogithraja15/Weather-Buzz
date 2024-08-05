import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_buzz/utils/api_endpoints.dart';

class NewsService {
  final String _apiKey = NEWS_API_KEY;
  final String _baseUrl = 'https://newsapi.org/v2/everything/';
  final String _hfApiUrl =
      'https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base';
  final String _hfApiKey = HUGGING_FACE_API_KEY;

  Future<List<Map<String, dynamic>>> fetchAllNews(String query,
      {int page = 1, int pageSize = 30}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?apiKey=$_apiKey&q=$query&page=$page&pageSize=$pageSize'),
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          List articles = data['articles'];
          final List<Map<String, dynamic>> filteredArticles =
              articles.where((article) {
            bool hasRequiredFields = article['title'] != null &&
                article['description'] != null &&
                article['content'] != null &&
                article['url'] != null &&
                article['urlToImage'] != null;

            return hasRequiredFields;
          }).map<Map<String, dynamic>>((article) {
            return {
              'title': article['title'],
              'description': article['description'],
              'content': article['content'],
              'author': article['author'],
              'urlToImage': article['urlToImage'],
              'url': article['url'],
            };
          }).toList();

          return filteredArticles;
        } else {
          throw Exception('Failed to load news: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> analyzeEmotion(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_hfApiUrl),
        headers: {
          'Authorization': 'Bearer $_hfApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'inputs': text}),
      );

      print("Emotion Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty && data.first is List) {
          final innerList = data.first as List;
          if (innerList.isNotEmpty && innerList.first is Map<String, dynamic>) {
            return innerList.first as Map<String, dynamic>;
          } else {
            throw Exception(
                'Expected a Map within the inner List for emotion analysis');
          }
        } else {
          throw Exception('Expected a List of Lists for emotion analysis');
        }
      } else {
        throw Exception('Failed to analyze emotion: ${response.statusCode}');
      }
    } catch (e) {
      print('Error analyzing emotion: $e');
      rethrow;
    }
  }
}
