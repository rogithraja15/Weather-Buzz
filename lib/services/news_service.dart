import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_buzz/utils/api_endpoints.env';

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final innerList = data.first as List;
        return innerList.first as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to analyze emotion, Try entering city name again');
      }
    } catch (e) {
      print('Caught exception: $e');
      rethrow;
    }
  }
}
