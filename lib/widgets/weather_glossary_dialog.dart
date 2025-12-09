import 'package:flutter/material.dart';

class WeatherGlossaryDialog extends StatelessWidget {
  final String term;

  const WeatherGlossaryDialog({super.key, required this.term});

  static const Map<String, String> _definitions = {
    'Humidity': 'Humidity is the amount of water vapor in the air. High humidity makes it feel hotter because sweat doesn\'t evaporate as easily.',
    'Pressure': 'Atmospheric pressure is the weight of the air above you. High pressure usually brings fair weather, while low pressure often brings storms.',
    'Feels Like': 'The "Feels Like" temperature takes into account wind, humidity, and sun to show how the weather actually feels to the human body.',
    'UV Index': 'The UV Index measures the strength of sunburn-producing ultraviolet radiation. Higher numbers mean greater risk of harm from unprotected sun exposure.',
    'Wind Degree': 'Wind degree indicates the direction the wind is coming from (0° is North, 90° is East, etc.).',
    'Visibility': 'Visibility is the distance one can see as determined by light and weather conditions.',
  };

  @override
  Widget build(BuildContext context) {
    // Normalize term to find definition
    final definition = _definitions.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase().contains(term.toLowerCase()),
          orElse: () => const MapEntry('Unknown', 'No definition available for this term.'),
        )
        .value;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.menu_book, color: Colors.blue),
          const SizedBox(width: 8),
          Text(term),
        ],
      ),
      content: Text(definition),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it!'),
        ),
      ],
    );
  }
}
