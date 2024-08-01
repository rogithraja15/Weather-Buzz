import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_buzz/providers/temp_provider.dart';
import 'package:weather_buzz/utils/constants.dart';
import 'package:weather_buzz/widgets/error_widget.dart';

class ForecastCard extends ConsumerWidget {
  const ForecastCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsyncValue = ref.watch(forecastProvider);

    return forecastAsyncValue.when(
      data: (forecasts) {
        return IntrinsicHeight(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: sizew(context) * 0.01),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: sizew(context) * 0.01),
                Text('5-DAYS FORECAST  ',
                    style: AppTheme.defaultTextStyle
                        .copyWith(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final forecast = forecasts[index * 8];
                    final temperature = forecast['temperature'] ?? 0.0;
                    final icon = forecast['icon'] ?? '01d';
                    final date = forecast['date'] ?? DateTime.now();

                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff2f6cae),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(sizew(context) * 0.01),
                        child: Column(
                          children: [
                            Image.network(
                              'http://openweathermap.org/img/wn/$icon@2x.png',
                              height: sizew(context) * 0.12,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: sizew(context) * 0.12,
                                  color: Colors.transparent,
                                );
                              },
                            ),
                            Text(
                              DateFormat('E').format(date),
                              style: AppTheme.defaultTextStyle,
                            ),
                            Text(
                              '${temperature.toStringAsFixed(0)}°',
                              style: AppTheme.defaultTextStyle
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: sizew(context) * 0.01),
              ],
            ),
          ),
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: IntrinsicHeight(
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: sizew(context) * 0.01),
                Container(
                  width: sizew(context) * 0.5,
                  height: sizeh(context) * 0.03,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(sizew(context) * 0.01),
                      child: Column(
                        children: [
                          Container(
                            width: sizew(context) * 0.12,
                            height: sizew(context) * 0.12,
                            color: Colors.white,
                          ),
                          SizedBox(height: sizeh(context) * 0.01),
                          Container(
                            width: sizew(context) * 0.08,
                            height: sizeh(context) * 0.02,
                            color: Colors.white,
                          ),
                          SizedBox(height: sizeh(context) * 0.01),
                          Container(
                            width: sizew(context) * 0.08,
                            height: sizeh(context) * 0.02,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: sizew(context) * 0.01),
              ],
            ),
          ),
        ),
      ),
      error: (error, stackTrace) {
        return const ForecastError();
      },
    );
  }
}
