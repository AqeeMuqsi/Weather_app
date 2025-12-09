import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/weather_map.dart';
import '../widgets/hourly_forecast_widget.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/wind_card.dart';
import '../widgets/sunrise_sunset_card.dart';
import '../widgets/air_quality_card.dart';
import '../widgets/weather_details_grid.dart';
import '../widgets/weekly_summary_card.dart';
import '../widgets/future_prediction_card.dart';
import '../widgets/share_weather_card.dart';
import '../widgets/clothing_suggestion_card.dart';
import '../widgets/did_you_know_card.dart';
import '../widgets/moon_phase_card.dart';

import 'search_screen.dart';
import 'favourites_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';
import 'compare_cities_screen.dart';
import 'weather_by_date_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyWatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavouritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlertsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'compare') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CompareCitiesScreen()),
                );
              } else if (value == 'date') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeatherByDateScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 12),
                    Text('Weather by Date'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'compare',
                child: Row(
                  children: [
                    Icon(Icons.compare_arrows),
                    SizedBox(width: 12),
                    Text('Compare Cities'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        weatherCondition: provider.currentWeather?.condition ?? 'Clear',
        isDark: Theme.of(context).brightness == Brightness.dark,
        child: RefreshIndicator(
          onRefresh: () => provider.fetchWeatherByLocation(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.errorMessage != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.fetchWeatherByLocation();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (provider.currentWeather != null)
                WeatherCard(weather: provider.currentWeather!)
              else
                const Text('No weather data available'),
              const SizedBox(height: 16),
              if (provider.currentWeather != null) ...[
                WeatherDetailsGrid(
                  feelsLike: provider.currentWeather!.feelsLike,
                  humidity: provider.currentWeather!.humidity,
                  pressure: provider.currentWeather!.pressure,
                ),
                const SizedBox(height: 16),
                ClothingSuggestionCard(
                  temperature: provider.currentWeather!.temperature,
                  condition: provider.currentWeather!.condition,
                  windSpeed: provider.currentWeather!.windSpeed,
                ),
                const SizedBox(height: 16),
                ShareWeatherCard(
                  cityName: provider.currentWeather!.cityName,
                  temperature: provider.currentWeather!.temperature,
                  condition: provider.currentWeather!.condition,
                  feelsLike: '${provider.currentWeather!.feelsLike.round()}°',
                ),
                const SizedBox(height: 16),
                WindCard(
                  windSpeed: provider.currentWeather!.windSpeed,
                  windDegree: provider.currentWeather!.windDegree,
                ),
                const SizedBox(height: 16),
                SunriseSunsetCard(
                  sunrise: provider.currentWeather!.sunrise,
                  sunset: provider.currentWeather!.sunset,
                ),
                const SizedBox(height: 16),
                const MoonPhaseCard(),
                const SizedBox(height: 16),
                const DidYouKnowCard(),
                const SizedBox(height: 16),
                // Mock AQI for demo - in production, fetch from air quality API
                const AirQualityCard(aqi: 45),
              ],
              const SizedBox(height: 16),
              if (provider.hourlyForecast.isNotEmpty) ...[
                HourlyForecastWidget(hourlyForecast: provider.hourlyForecast),
                const SizedBox(height: 16),
              ],
              if (provider.currentWeather != null)
                WeatherMap(
                  latitude: provider.currentWeather!.latitude,
                  longitude: provider.currentWeather!.longitude,
                  cityName: provider.currentWeather!.cityName,
                ),
              const SizedBox(height: 16),
              if (provider.forecast.isNotEmpty) ...[
                WeeklySummaryCard(forecast: provider.forecast),
                const SizedBox(height: 16),
                FuturePredictionCard(forecast: provider.forecast),
                const SizedBox(height: 16),
                Text(
                  '📊 7-Day Temperature Chart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                TemperatureChart(forecast: provider.forecast),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
