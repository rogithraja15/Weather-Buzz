import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_buzz/models/weather_model.dart';
import 'package:weather_buzz/screens/settings.dart';
import 'package:weather_buzz/utils/constants.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Icon(
                      Icons.location_on,
                      color: AppTheme.iconColor,
                      size: sizew(context) * 0.07,
                    ),
                    Text(
                      'Unknown',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sizew(context) * 0.05,
                          color: AppTheme.textColor),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black)
                  ],
                ),
                _dateTime(DateTime.now()),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              icon: Icon(Icons.settings, size: 35, color: AppTheme.iconColor),
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
                        'N/A°',
                        style: AppTheme.headingTextStyle,
                      ),
                      Text(
                        'No Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: sizew(context) * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: sizeh(context) * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const IconText(icon: Icons.water, text: 'N/A%'),
                          SizedBox(width: sizew(context) * 0.01),
                          const IconText(icon: Icons.air, text: 'N/A km/hr'),
                        ],
                      ),
                      SizedBox(height: sizeh(context) * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const IconText(
                              icon: Icons.wb_cloudy_outlined, text: 'N/A%'),
                          SizedBox(width: sizew(context) * 0.01),
                          const IconText(
                              icon: CupertinoIcons.sunrise, text: 'N/A'),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -30,
                  right: -100,
                  child: Container(
                    height: sizeh(context) * 0.2,
                    width: sizew(context),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

class ForecastError extends StatelessWidget {
  const ForecastError({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: AppTheme.defaultTextStyle.copyWith(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
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
                        Container(
                          height: sizew(context) * 0.12,
                          width: sizew(context) * 0.12,
                          color: Colors.transparent,
                        ),
                        Text(
                          'No Data',
                          style: AppTheme.defaultTextStyle,
                        ),
                        Text(
                          'N/A°',
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
  }
}
