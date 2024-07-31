import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_buzz/providers/news_provider.dart';
import 'package:weather_buzz/screens/news_page.dart';
import 'package:weather_buzz/utils/constants.dart';

class NewsWidget extends ConsumerWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider);
    final newsAsyncValue = ref.watch(newsProvider);
    final newsCategory = ref.watch(newsCategoryProvider);

    Color cardColor;
    String categoryText;

    switch (newsCategory) {
      case 'depressing':
        cardColor = Colors.blueAccent;
        categoryText = 'Depressing';
        break;
      case 'fear':
        cardColor = Colors.redAccent;
        categoryText = 'Fear';
        break;
      case 'happiness':
        cardColor = Colors.green;
        categoryText = 'Happiness';
        break;
      default:
        cardColor = Colors.grey;
        categoryText = 'Unknown';
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2b2e35),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: -10,
            blurRadius: 15,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      height: sizeh(context) * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sizew(context) * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('WEATHER BASED NEWS',
                  style: TextStyle(
                      color: Colors.white, fontSize: sizew(context) * 0.035)),
              SizedBox(width: sizew(context) * 0.001),
              weatherAsyncValue.when(
                data: (weather) {
                  final tempInCelsius = weather.temperature?.celsius ?? 0;
                  final autoCategory = tempInCelsius <= 10
                      ? 'depressing'
                      : tempInCelsius >= 30
                          ? 'fear'
                          : 'happiness';

                  final displayCategory = newsCategory != autoCategory
                      ? newsCategory
                      : autoCategory;

                  switch (displayCategory) {
                    case 'depressing':
                      cardColor = Colors.blueAccent;
                      categoryText = 'Depressing';
                      break;
                    case 'fear':
                      cardColor = Colors.redAccent;
                      categoryText = 'Fear';
                      break;
                    case 'happiness':
                      cardColor = Colors.green;
                      categoryText = 'Happiness';
                      break;
                    default:
                      cardColor = Colors.grey;
                      categoryText = 'Unknown';
                  }

                  return Card(
                    color: cardColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        categoryText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: sizew(context) * 0.03),
                      ),
                    ),
                  );
                },
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: sizew(context) * 0.4,
                    height: sizeh(context) * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
          Expanded(
            child: newsAsyncValue.when(
              data: (newsItems) {
                if (newsItems.isEmpty) {
                  return const Center(child: Text('No news available'));
                }

                return ListView.builder(
                  itemCount: newsItems.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsItems[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedNewsPage(
                              title: newsItem['title'] ?? 'No Title',
                              description:
                                  newsItem['description'] ?? 'No Description',
                              content: newsItem['content'] ?? 'No Content',
                              author: newsItem['author'] ?? 'Unknown Author',
                              imageUrl: newsItem['urlToImage'] ?? '',
                              url: newsItem['url'] ?? '',
                            ),
                          ),
                        );
                      },
                      leading: newsItem['urlToImage'] != null
                          ? AspectRatio(
                              aspectRatio: 1.6 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  newsItem['urlToImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 1.6 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      title: Text(
                        newsItem['title'] ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        newsItem['description'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12),
                      ),
                    );
                  },
                );
              },
              loading: () => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    leading: Container(
                      width: sizew(context) * 0.4,
                      height: sizeh(context) * 0.1,
                      color: Colors.white,
                    ),
                    title: Container(
                      height: sizeh(context) * 0.02,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      height: sizeh(context) * 0.015,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
