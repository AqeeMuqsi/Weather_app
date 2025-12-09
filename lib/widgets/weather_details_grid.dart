import 'package:flutter/material.dart';
import 'weather_glossary_dialog.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final double feelsLike;
  final int humidity;
  final int pressure;

  const WeatherDetailsGrid({
    super.key,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Expanded(
          child: _buildDetailCard(
            context: context,
            icon: Icons.thermostat_outlined,
            label: 'Feels Like',
            value: '${feelsLike.round()}°',
            gradient: isDark
                ? const [Color(0xFFFF6B6B), Color(0xFFEE5A6F)]
                : const [Color(0xFFFA8BFF), Color(0xFF2BD2FF)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            context: context,
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '$humidity%',
            gradient: isDark
                ? const [Color(0xFF4E65FF), Color(0xFF92EFFD)]
                : const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            context: context,
            icon: Icons.compress_outlined,
            label: 'Pressure',
            value: '$pressure\nhPa',
            gradient: isDark
                ? const [Color(0xFFFF9A44), Color(0xFFFC6076)]
                : const [Color(0xFFFEAC5E), Color(0xFFC779D0)],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => WeatherGlossaryDialog(term: label),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: gradient,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
