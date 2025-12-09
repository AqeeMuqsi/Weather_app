import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/app_background.dart';
import 'package:intl/intl.dart';

class WeatherByDateScreen extends StatefulWidget {
  const WeatherByDateScreen({super.key});

  @override
  State<WeatherByDateScreen> createState() => _WeatherByDateScreenState();
}

class _WeatherByDateScreenState extends State<WeatherByDateScreen> {
  DateTime? _selectedDate;
  Map<String, dynamic>? _weatherData;
  bool _isLoadingForecast = false;

  @override
  void initState() {
    super.initState();
    // Load forecast data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureForecastLoaded();
    });
  }

  Future<void> _ensureForecastLoaded() async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    
    if (provider.forecast.isEmpty && !_isLoadingForecast) {
      setState(() {
        _isLoadingForecast = true;
      });
      
      try {
        await provider.fetchWeatherByLocation();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading forecast: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingForecast = false;
          });
        }
      }
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchWeatherForDate();
    }
  }

  void _fetchWeatherForDate() {
    if (_selectedDate == null) return;

    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final forecast = provider.forecast;

    // Ensure forecast data is available
    if (forecast.isEmpty) {
      setState(() {
        _weatherData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Forecast data not available. Please go to home screen first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Calculate days difference
    final now = DateTime.now();
    final selectedDateOnly = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    final nowDateOnly = DateTime(now.year, now.month, now.day);
    final daysDiff = selectedDateOnly.difference(nowDateOnly).inDays;
    
    debugPrint('Selected date: $selectedDateOnly');
    debugPrint('Current date: $nowDateOnly');
    debugPrint('Days difference: $daysDiff');
    debugPrint('Forecast length: ${forecast.length}');
    
    if (daysDiff >= 0 && daysDiff < forecast.length) {
      final dayForecast = forecast[daysDiff];
      setState(() {
        _weatherData = {
          'date': dayForecast.date,
          'minTemp': dayForecast.minTemp,
          'maxTemp': dayForecast.maxTemp,
          'condition': dayForecast.condition,
          'avgTemp': (dayForecast.minTemp + dayForecast.maxTemp) / 2,
        };
      });
      debugPrint('Weather data set: $_weatherData');
    } else {
      setState(() {
        _weatherData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Forecast not available for $daysDiff days ahead. Try a nearer date.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<WeatherProvider>(context);
    final hasForecast = provider.forecast.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Weather by Date'),
      ),
      body: AppBackground(
        isDark: isDark,
        child: _isLoadingForecast
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading forecast data...'),
                  ],
                ),
              )
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                        : [const Color(0xFF56CCF2), const Color(0xFF2F80ED)],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select a Date',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'View weather forecast for any date\nwithin the next 7 days',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _selectedDate == null
                            ? 'Pick a Date'
                            : DateFormat('EEEE, MMM d, y').format(_selectedDate!),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!hasForecast && !_isLoadingForecast) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade800),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Forecast data is loading. Please wait...',
                          style: TextStyle(color: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_weatherData != null) ...[
              const SizedBox(height: 24),
              _buildWeatherForecastCard(isDark),
            ] else if (_selectedDate != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading forecast data...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            _buildInstructionsCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherForecastCard(bool isDark) {
    final temp = _weatherData!['avgTemp'];
    final condition = _weatherData!['condition'];
    final minTemp = _weatherData!['minTemp'];
    final maxTemp = _weatherData!['maxTemp'];
    final date = _weatherData!['date'] as DateTime;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientForCondition(condition, isDark),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              DateFormat('EEEE').format(date),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              DateFormat('MMMM d, y').format(date),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              _getWeatherIcon(condition),
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              condition,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTempBox('High', maxTemp, Icons.arrow_upward),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${temp.round()}°',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _buildTempBox('Low', minTemp, Icons.arrow_downward),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      _getAdviceForCondition(condition),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildTempBox(String label, double temp, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
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
          '${temp.round()}°',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard(bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'How to Use',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInstruction('1', 'Tap "Pick a Date" button above'),
            _buildInstruction('2', 'Select any date within next 7 days'),
            _buildInstruction('3', 'View detailed weather forecast'),
            _buildInstruction('4', 'Plan your activities accordingly!'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientForCondition(String condition, bool isDark) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDark
            ? [const Color(0xFFFF6B6B), const Color(0xFFFFD93D)]
            : [const Color(0xFFFFA726), const Color(0xFFFFEB3B)];
      case 'clouds':
        return isDark
            ? [const Color(0xFF757F9A), const Color(0xFFD7DDE8)]
            : [const Color(0xFF89F7FE), const Color(0xFF66A6FF)];
      case 'rain':
      case 'drizzle':
        return isDark
            ? [const Color(0xFF4E54C8), const Color(0xFF8F94FB)]
            : [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];
      default:
        return isDark
            ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
            : [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    }
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

  String _getAdviceForCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'Perfect day for outdoor activities! Don\'t forget sunscreen.';
      case 'clouds':
        return 'Comfortable weather. Great for a walk or outdoor plans.';
      case 'rain':
      case 'drizzle':
        return 'Bring an umbrella! Indoor activities recommended.';
      case 'thunderstorm':
        return 'Stay indoors. Avoid outdoor activities during storms.';
      case 'snow':
        return 'Dress warmly! Winter activities possible.';
      default:
        return 'Check local conditions before heading out.';
    }
  }
}
