import 'package:flutter/material.dart';
import 'package:weather_buzz/utils/constants.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: sizew(context) * 0.055,
          color: Colors.blue,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style:
              TextStyle(fontSize: sizew(context) * 0.033, color: Colors.white),
        ),
      ],
    );
  }
}
