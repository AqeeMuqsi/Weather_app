import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunriseSunsetCard({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayDuration = sunset.difference(sunrise).inMinutes;
    final elapsed = now.isAfter(sunrise) && now.isBefore(sunset)
        ? now.difference(sunrise).inMinutes
        : 0;
    final progress = elapsed / dayDuration;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A6F)]
                : [const Color(0xFFFFD93D), const Color(0xFFFF6B6B)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Sunrise',
                  time: DateFormat('hh:mm a').format(sunrise),
                ),
                _buildTimeInfo(
                  icon: Icons.nights_stay_rounded,
                  label: 'Sunset',
                  time: DateFormat('hh:mm a').format(sunset),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (progress > 0 && progress < 1)
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.85 * progress - 12,
                    top: -4,
                    child: const Icon(
                      Icons.wb_sunny,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
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
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
