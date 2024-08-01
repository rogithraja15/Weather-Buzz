import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_buzz/models/weather_model.dart';
import 'package:weather_buzz/providers/news_provider.dart';
import 'package:weather_buzz/providers/temp_provider.dart';
import 'package:weather_buzz/screens/settings.dart';
import 'package:weather_buzz/utils/constants.dart';
import 'package:weather_buzz/widgets/error_widget.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider);
    final isCelsius = ref.watch(temperatureUnitProvider);

    return weatherAsyncValue.when(
      data: (weather) {
        final areaName = weather.areaName ?? 'Unknown';
        final dateTime = weather.date ?? DateTime.now();
        final temperature = isCelsius
            ? weather.temperature?.celsius?.toStringAsFixed(0) ?? 'N/A'
            : weather.temperature?.fahrenheit?.toStringAsFixed(0) ?? 'N/A';
        final weatherDescription =
            toBeginningOfSentenceCase(weather.weatherDescription ?? 'No Data');
        final humidity = weather.humidity?.toStringAsFixed(0) ?? 'N/A';
        final windSpeed = weather.windSpeed?.toStringAsFixed(0) ?? 'N/A';
        final cloudiness = weather.cloudiness?.toStringAsFixed(0) ?? 'N/A';
        final sunrise = weather.sunrise != null
            ? DateFormat('h:mm a').format(weather.sunrise!)
            : 'N/A';
        final weatherIcon = weather.weatherIcon ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        final TextEditingController controller =
                            TextEditingController(text: areaName);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Change Area Name'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new area name',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(areaNameProvider.notifier).state =
                                        controller.text;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppTheme.iconColor,
                            size: sizew(context) * 0.07,
                          ),
                          Text(
                            areaName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: sizew(context) * 0.05,
                                color: AppTheme.textColor),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.black)
                        ],
                      ),
                    ),
                    _dateTime(dateTime),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                  icon:
                      Icon(Icons.settings, size: 35, color: AppTheme.iconColor),
                )
              ],
            ),
            SizedBox(height: sizeh(context) * 0.015),
            IntrinsicHeight(
              child: Container(
                width: sizew(context),
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
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temperature°',
                            style: AppTheme.headingTextStyle,
                          ),
                          Text(
                            weatherDescription,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: sizew(context) * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: sizeh(context) * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconText(icon: Icons.water, text: '$humidity%'),
                              SizedBox(width: sizew(context) * 0.01),
                              IconText(
                                  icon: Icons.air, text: '$windSpeed km/hr'),
                            ],
                          ),
                          SizedBox(height: sizeh(context) * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconText(
                                  icon: Icons.wb_cloudy_outlined,
                                  text: '$cloudiness%'),
                              SizedBox(width: sizew(context) * 0.01),
                              IconText(
                                  icon: CupertinoIcons.sunrise, text: sunrise),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      right: -100,
                      child: weatherIcon.isNotEmpty
                          ? Image.network(
                              'http://openweathermap.org/img/wn/$weatherIcon@4x.png',
                              height: sizeh(context) * 0.2,
                              width: sizew(context),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 80,
                          height: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 100,
                      height: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
                const Icon(
                  Icons.settings,
                  size: 35,
                  color: Colors.grey,
                )
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: sizeh(context) / 4.2,
              width: sizew(context),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 120,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 50,
                              height: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: sizew(context) * 0.01),
                            Container(
                              width: 80,
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 50,
                              height: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: sizew(context) * 0.01),
                            Container(
                              width: 80,
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -40,
                    right: -100,
                    child: Container(
                      height: sizeh(context) * 0.25,
                      width: sizew(context),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(color: Colors.red[700]),
                ),
                content: const Text('City not found. Try other cities'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                    ),
                  ),
                ],
              );
            },
          );
        });
        return const WeatherError();
      },
    );
  }

  Widget _dateTime(DateTime dateTime) {
    return Row(
      children: [
        Text(
          "  Last updated: ${DateFormat('h:mm a').format(dateTime)}",
          style: TextStyle(fontSize: 12, color: AppTheme.textColor),
        ),
        Text(
          DateFormat(' E').format(dateTime),
          style: TextStyle(fontSize: 12, color: AppTheme.textColor),
        ),
      ],
    );
  }
}
