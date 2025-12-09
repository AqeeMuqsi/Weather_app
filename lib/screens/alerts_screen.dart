import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _getSeverityColor(String alert) {
    final lowercaseAlert = alert.toLowerCase();
    
    if (lowercaseAlert.contains('extreme') || 
        lowercaseAlert.contains('severe') ||
        lowercaseAlert.contains('tornado') ||
        lowercaseAlert.contains('hurricane')) {
      return const Color(0xFFD32F2F); // Red
    } else if (lowercaseAlert.contains('warning') ||
               lowercaseAlert.contains('thunderstorm') ||
               lowercaseAlert.contains('flood')) {
      return const Color(0xFFFF6F00); // Orange
    } else if (lowercaseAlert.contains('watch') ||
               lowercaseAlert.contains('advisory')) {
      return const Color(0xFFFBC02D); // Yellow
    }
    return const Color(0xFF1976D2); // Blue (information)
  }

  IconData _getAlertIcon(String alert) {
    final lowercaseAlert = alert.toLowerCase();
    
    if (lowercaseAlert.contains('tornado')) {
      return Icons.cyclone;
    } else if (lowercaseAlert.contains('flood') || 
               lowercaseAlert.contains('rain')) {
      return Icons.water;
    } else if (lowercaseAlert.contains('wind')) {
      return Icons.air;
    } else if (lowercaseAlert.contains('snow') || 
               lowercaseAlert.contains('ice')) {
      return Icons.ac_unit;
    } else if (lowercaseAlert.contains('heat')) {
      return Icons.wb_sunny;
    } else if (lowercaseAlert.contains('thunderstorm') || 
               lowercaseAlert.contains('lightning')) {
      return Icons.thunderstorm;
    }
    return Icons.warning_amber_rounded;
  }

  String _getSeverityLabel(String alert) {
    final lowercaseAlert = alert.toLowerCase();
    
    if (lowercaseAlert.contains('extreme') || 
        lowercaseAlert.contains('severe')) {
      return 'EXTREME';
    } else if (lowercaseAlert.contains('warning')) {
      return 'WARNING';
    } else if (lowercaseAlert.contains('watch')) {
      return 'WATCH';
    } else if (lowercaseAlert.contains('advisory')) {
      return 'ADVISORY';
    }
    return 'INFO';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚠️ Weather Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.fetchWeatherByLocation();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F0F1E), const Color(0xFF1A1A2E)]
                : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
          ),
        ),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.alerts.isEmpty
                ? _buildNoAlertsView(context)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildAlertsSummary(provider.alerts.length, isDark),
                      const SizedBox(height: 16),
                      ...provider.alerts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final alert = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildAlertCard(
                            context,
                            alert,
                            index + 1,
                            provider.alerts.length,
                            isDark,
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      _buildSafetyTips(isDark),
                    ],
                  ),
      ),
    );
  }

  Widget _buildNoAlertsView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'All Clear!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No active weather alerts',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'in your area right now',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Stay Weather Aware',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll notify you immediately if any\nweather alerts are issued for your location.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSummary(int count, bool isDark) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Alerts',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count Alert${count > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateTime.now().toString().split(' ')[0],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String alert,
    int number,
    int total,
    bool isDark,
  ) {
    final color = _getSeverityColor(alert);
    final icon = _getAlertIcon(alert);
    final severity = _getSeverityLabel(alert);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                severity,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Alert $number/$total',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Issued: ${DateTime.now().toString().split('.')[0]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getAlertDescription(alert),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTips(bool isDark) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF4E65FF), const Color(0xFF92EFFD)]
                : [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Safety Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSafetyTip('Stay indoors during severe weather'),
            _buildSafetyTip('Keep emergency supplies ready'),
            _buildSafetyTip('Monitor weather updates regularly'),
            _buildSafetyTip('Have an evacuation plan'),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAlertDescription(String alert) {
    final lowercaseAlert = alert.toLowerCase();
    
    if (lowercaseAlert.contains('thunderstorm')) {
      return 'Severe thunderstorms expected. Lightning, heavy rain, and strong winds possible. Seek shelter immediately.';
    } else if (lowercaseAlert.contains('tornado')) {
      return 'Tornado warning in effect. Take shelter in a basement or interior room immediately. Stay away from windows.';
    } else if (lowercaseAlert.contains('flood')) {
      return 'Flooding expected. Avoid low-lying areas and do not drive through flooded roads.';
    } else if (lowercaseAlert.contains('heat')) {
      return 'Excessive heat warning. Drink plenty of water and limit outdoor activities during peak hours.';
    } else if (lowercaseAlert.contains('snow') || lowercaseAlert.contains('winter')) {
      return 'Winter weather advisory. Hazardous travel conditions expected. Drive carefully.';
    } else if (lowercaseAlert.contains('wind')) {
      return 'High wind warning. Secure loose objects and avoid being outside.';
    }
    
    return 'Please monitor local weather conditions and follow safety guidelines. Stay informed through official weather sources.';
  }
}
