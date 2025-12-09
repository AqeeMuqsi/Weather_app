import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareWeatherCard extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String condition;
  final String feelsLike;

  const ShareWeatherCard({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.feelsLike,
  });

  void _shareWeather(BuildContext context) {
    final weatherText = '''
🌤️ Weather Update for $cityName

Temperature: ${temperature.round()}°
Condition: $condition
Feels Like: $feelsLike

Shared from SkyWatch Weather App 📱
Developed by Aqeela
    ''';

    Clipboard.setData(ClipboardData(text: weatherText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Weather info copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF834D9B), const Color(0xFFD04ED6)]
                : [const Color(0xFFFA709A), const Color(0xFFFEE140)],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.share,
              color: Colors.white,
              size: 28,
            ),
          ),
          title: const Text(
            'Share Weather',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: const Text(
            'Share with friends & family',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => _shareWeather(context),
          ),
          onTap: () => _shareWeather(context),
        ),
      ),
    );
  }
}
