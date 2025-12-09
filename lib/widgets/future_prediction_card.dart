import 'package:flutter/material.dart';
import '../models/daily_forecast.dart';
import 'package:intl/intl.dart';

class FuturePredictionCard extends StatelessWidget {
  final List<DailyForecast> forecast;

  const FuturePredictionCard({
    super.key,
    required this.forecast,
  });

  String _predictTrend() {
    if (forecast.length < 3) return 'Not enough data';
    
    final temps = forecast.take(3).map((f) => (f.minTemp + f.maxTemp) / 2).toList();
    
    if (temps[0] < temps[1] && temps[1] < temps[2]) {
      return '📈 Getting Warmer';
    } else if (temps[0] > temps[1] && temps[1] > temps[2]) {
      return '📉 Getting Cooler';
    } else {
      return '➡️ Staying Stable';
    }
  }

  String _predictRainChance() {
    if (forecast.isEmpty) return 'Unknown';
    
    final rainyDays = forecast.where((f) => 
      f.condition.toLowerCase().contains('rain') || 
      f.condition.toLowerCase().contains('drizzle')
    ).length;
    
    final percentage = (rainyDays / forecast.length * 100).round();
    
    if (percentage > 60) return '🌧️ High ($percentage%)';
    if (percentage > 30) return '⛅ Moderate ($percentage%)';
    return '☀️ Low ($percentage%)';
  }

  String _getAdvice() {
    if (forecast.isEmpty) return 'No forecast available';
    
    final trend = _predictTrend();
    final conditions = forecast.map((f) => f.condition.toLowerCase()).toList();
    
    if (conditions.any((c) => c.contains('rain'))) {
      return '🌂 Don\'t forget your umbrella this week!';
    } else if (trend.contains('Warmer')) {
      return '☀️ Perfect weather ahead! Plan outdoor activities.';
    } else if (trend.contains('Cooler')) {
      return '🧥 Bring a jacket, temperatures dropping.';
    } else {
      return '✨ Stable weather expected all week.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextDays = forecast.take(3).toList();

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                : [const Color(0xFF4ECDC4), const Color(0xFF556270)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '🔮 Future Prediction',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPredictionRow('Temperature Trend', _predictTrend()),
            const SizedBox(height: 12),
            _buildPredictionRow('Rain Probability', _predictRainChance()),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.yellowAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getAdvice(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white38),
            const SizedBox(height: 12),
            const Text(
              'Next 3 Days Forecast',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: nextDays.map((day) {
                final date = DateFormat('EEE').format(day.date);
                final avgTemp = (day.minTemp + day.maxTemp) / 2;
                return _buildDayPreview(date, avgTemp, day.condition);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDayPreview(String day, double temp, String condition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            _getWeatherIcon(condition),
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '${temp.round()}°',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
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
}
