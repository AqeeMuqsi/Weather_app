import 'dart:math';
import 'package:flutter/material.dart';

class DidYouKnowCard extends StatefulWidget {
  const DidYouKnowCard({super.key});

  @override
  State<DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<DidYouKnowCard> {
  final List<String> _facts = [
    "Lightning strikes the Earth about 100 times every second.",
    "A single bolt of lightning can release enough energy to toast 100,000 slices of bread.",
    "Raindrops can fall as fast as 22 miles per hour.",
    "The sun is over 300,000 times larger than Earth.",
    "Clouds look white because they reflect all colors of sunlight equally.",
    "A hurricane releases enough energy in one second to explode a 10-megaton nuclear bomb.",
    "The hottest temperature ever recorded on Earth was 134°F (56.7°C) in Death Valley, USA.",
    "Snowflakes always have 6 sides due to the molecular structure of ice.",
    "The smell of rain is caused by a bacteria called actinomycetes.",
    "You can tell the temperature by counting a cricket's chirps!"
  ];

  late String _currentFact;

  @override
  void initState() {
    super.initState();
    _randomizeFact();
  }

  void _randomizeFact() {
    setState(() {
      _currentFact = _facts[Random().nextInt(_facts.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Did You Know?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentFact,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _randomizeFact,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Next Fact'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
