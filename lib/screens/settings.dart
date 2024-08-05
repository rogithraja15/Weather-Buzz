import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_buzz/providers/news_provider.dart';
import 'package:weather_buzz/providers/temp_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCelsius = ref.watch(temperatureUnitProvider);
    final currentCategory = ref.watch(newsCategoryProvider);

    String capitalizeFirstLetter(String text) {
      if (text.isEmpty) {
        return text;
      }
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ListTile(
            trailing: Switch(
              activeColor: Colors.blue,
              value: isCelsius,
              onChanged: (bool value) {
                ref.read(temperatureUnitProvider.notifier).state = value;
              },
            ),
            title: const Text('Switch to Celsius'),
          ),
          ListTile(
            trailing: PopupMenuButton<String>(
              color: Colors.blue[100],
              onSelected: (String selectedCategory) {
                ref.read(newsCategoryProvider.notifier).state =
                    selectedCategory.toLowerCase();
              },
              itemBuilder: (BuildContext context) {
                return ['sadness', 'fear', 'joy'].map((String category) {
                  return PopupMenuItem<String>(
                    value: category.toLowerCase(),
                    child: Text(category),
                  );
                }).toList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(capitalizeFirstLetter(currentCategory)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            title: const Text('Change news category'),
          ),
        ],
      ),
    );
  }
}
