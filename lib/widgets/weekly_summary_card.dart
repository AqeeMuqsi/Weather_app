import 'package:flutter/material.dart';
import '../models/daily_forecast.dart';

class WeeklySummaryCard extends StatelessWidget {
  final List<DailyForecast> forecast;

  const WeeklySummaryCard({
    super.key,
    required this.forecast,
  });

  String _getMostCommonCondition() {
    if (forecast.isEmpty) return 'Clear';
    
    final conditions = forecast.map((f) => f.condition).toList();
    final counts = <String, int>{};
    
    for (var condition in conditions) {
      counts[condition] = (counts[condition] ?? 0) + 1;
    }
    
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _getAverageTemp() {
    if (forecast.isEmpty) return 0;
    final sum = forecast.fold(0.0, (sum, f) => sum + (f.minTemp + f.maxTemp) / 2);
    return sum / forecast.length;
  }

  double _getMaxTemp() {
    if (forecast.isEmpty) return 0;
    return forecast.map((f) => f.maxTemp).reduce((a, b) => a > b ? a : b);
  }

  double _getMinTemp() {
    if (forecast.isEmpty) return 0;
    return forecast.map((f) => f.minTemp).reduce((a, b) => a < b ? a : b);
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mostCommon = _getMostCommonCondition();
    final avgTemp = _getAverageTemp();
    final maxTemp = _getMaxTemp();
    final minTemp = _getMinTemp();

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFFFF6B6B), const Color(0xFF556270)]
                : [const Color(0xFFFFD93D), const Color(0xFFFF6B6B)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '📅 Weekly Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: _getWeatherIcon(mostCommon),
                  label: 'Most Common',
                  value: mostCommon,
                ),
                _buildSummaryItem(
                  icon: Icons.thermostat,
                  label: 'Average',
                  value: '${avgTemp.round()}°',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        '${maxTemp.round()}°',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'High',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 2,
                    height: 60,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Column(
                    children: [
                      const Icon(Icons.arrow_downward, color: Colors.white, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        '${minTemp.round()}°',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Low',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 40),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
