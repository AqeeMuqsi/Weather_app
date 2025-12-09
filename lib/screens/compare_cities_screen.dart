import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CompareCitiesScreen extends StatefulWidget {
  const CompareCitiesScreen({super.key});

  @override
  State<CompareCitiesScreen> createState() => _CompareCitiesScreenState();
}

class _CompareCitiesScreenState extends State<CompareCitiesScreen> {
  final TextEditingController _city1Controller = TextEditingController();
  final TextEditingController _city2Controller = TextEditingController();
  
  Map<String, dynamic>? _city1Data;
  Map<String, dynamic>? _city2Data;
  bool _isLoading = false;

  Future<void> _compareWeather() async {
    if (_city1Controller.text.isEmpty || _city2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both city names')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      
      // Fetch city 1
      await provider.fetchWeatherByCity(_city1Controller.text);
      _city1Data = {
        'name': provider.currentWeather?.cityName ?? 'Unknown',
        'temp': provider.currentWeather?.temperature ?? 0,
        'condition': provider.currentWeather?.condition ?? 'Unknown',
        'humidity': provider.currentWeather?.humidity ?? 0,
        'wind': provider.currentWeather?.windSpeed ?? 0,
      };

      // Fetch city 2
      await provider.fetchWeatherByCity(_city2Controller.text);
      _city2Data = {
        'name': provider.currentWeather?.cityName ?? 'Unknown',
        'temp': provider.currentWeather?.temperature ?? 0,
        'condition': provider.currentWeather?.condition ?? 'Unknown',
        'humidity': provider.currentWeather?.humidity ?? 0,
        'wind': provider.currentWeather?.windSpeed ?? 0,
      };

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔄 Compare Cities'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F0F1E), const Color(0xFF1A1A2E)]
                : [const Color(0xFFF0F4FF), const Color(0xFFE3F2FD)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Two Cities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _city1Controller,
                      decoration: InputDecoration(
                        labelText: 'City 1',
                        hintText: 'e.g., London',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _city2Controller,
                      decoration: InputDecoration(
                        labelText: 'City 2',
                        hintText: 'e.g., Tokyo',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _compareWeather,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.compare_arrows),
                        label: Text(_isLoading ? 'Comparing...' : 'Compare Weather'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_city1Data != null && _city2Data != null) ...[
              const SizedBox(height: 16),
              _buildComparisonCard(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(bool isDark) {
    final tempDiff = (_city1Data!['temp'] - _city2Data!['temp']).abs();
    final warmerCity = _city1Data!['temp'] > _city2Data!['temp'] 
        ? _city1Data!['name'] 
        : _city2Data!['name'];

    return Column(
      children: [
        Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.insights, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'Comparison Result',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$warmerCity is ${tempDiff.toStringAsFixed(1)}° warmer',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCityCard(_city1Data!, isDark, true)),
            const SizedBox(width: 12),
            Expanded(child: _buildCityCard(_city2Data!, isDark, false)),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailedComparison(isDark),
      ],
    );
  }

  Widget _buildCityCard(Map<String, dynamic> data, bool isDark, bool isCity1) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isCity1
                ? [const Color(0xFF56CCF2), const Color(0xFF2F80ED)]
                : [const Color(0xFFF093FB), const Color(0xFFF5576C)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              data['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '${data['temp'].round()}°',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              data['condition'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetric(Icons.water_drop, '${data['humidity']}%'),
            const SizedBox(height: 8),
            _buildMetric(Icons.air, '${data['wind'].toStringAsFixed(1)} m/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedComparison(bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow(
              'Temperature',
              '${_city1Data!['temp'].round()}°',
              '${_city2Data!['temp'].round()}°',
              _city1Data!['temp'] > _city2Data!['temp'],
            ),
            const Divider(),
            _buildComparisonRow(
              'Humidity',
              '${_city1Data!['humidity']}%',
              '${_city2Data!['humidity']}%',
              _city1Data!['humidity'] < _city2Data!['humidity'],
            ),
            const Divider(),
            _buildComparisonRow(
              'Wind Speed',
              '${_city1Data!['wind'].toStringAsFixed(1)} m/s',
              '${_city2Data!['wind'].toStringAsFixed(1)} m/s',
              _city1Data!['wind'] < _city2Data!['wind'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value1, String value2, bool city1Better) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (city1Better) const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(value1, textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (!city1Better) const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(value2, textAlign: TextAlign.center)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
