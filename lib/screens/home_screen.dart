import 'package:flutter/material.dart';
import 'package:weather_buzz/utils/constants.dart';
import 'package:weather_buzz/widgets/forecast_widget.dart';
import 'package:weather_buzz/widgets/news_widget.dart';
import 'package:weather_buzz/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white70, Color(0xff2b2e35)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: sizeh(context) * 0.02),
                    const WeatherCard(),
                    SizedBox(height: sizeh(context) * 0.02),
                    const ForecastCard(),
                  ],
                ),
                SizedBox(
                  height: sizeh(context) * 0.02,
                ),
                const NewsWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
