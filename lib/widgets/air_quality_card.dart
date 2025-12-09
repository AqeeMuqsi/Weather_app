import 'package:flutter/material.dart';

class AirQualityCard extends StatelessWidget {
  final int aqi;

  const AirQualityCard({
    super.key,
    required this.aqi,
  });

  String _getAQILevel() {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color _getAQIColor() {
    if (aqi <= 50) return const Color(0xFF00E400);
    if (aqi <= 100) return const Color(0xFFFFFF00);
    if (aqi <= 150) return const Color(0xFFFF7E00);
    if (aqi <= 200) return const Color(0xFFFF0000);
    if (aqi <= 300) return const Color(0xFF8F3F97);
    return const Color(0xFF7E0023);
  }

  IconData _getAQIIcon() {
    if (aqi <= 100) return Icons.sentiment_very_satisfied;
    if (aqi <= 150) return Icons.sentiment_neutral;
    if (aqi <= 200) return Icons.sentiment_dissatisfied;
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              _getAQIColor().withOpacity(0.2),
              _getAQIColor().withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getAQIColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getAQIIcon(),
                color: _getAQIColor(),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Air Quality Index',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAQILevel(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getAQIColor(),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$aqi',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: _getAQIColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
