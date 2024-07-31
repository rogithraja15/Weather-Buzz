import 'package:flutter/material.dart';
import 'package:weather_buzz/utils/constants.dart';

class DetailedNewsPage extends StatelessWidget {
  final String title;
  final String description;
  final String content;
  final String author;
  final String imageUrl;
  final String url;

  const DetailedNewsPage({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.imageUrl,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black26, Colors.blueGrey],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xff2b2e35),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (imageUrl.isNotEmpty)
                  Stack(children: [
                    Image.network(imageUrl),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                  ]),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: sizew(context) * 0.055,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(description, style: AppTheme.subtitleTextStyle),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(author,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white))),
                      const SizedBox(height: 10),
                      Text(content, style: AppTheme.subtitle2TextStyle)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
