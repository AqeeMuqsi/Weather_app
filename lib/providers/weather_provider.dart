import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/weather.dart';
import '../models/daily_forecast.dart';
import '../models/hourly_forecast.dart';
import '../services/api_service.dart';
import 'settings_provider.dart';

class WeatherProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  SettingsProvider? _settingsProvider;

  Weather? _currentWeather;
  List<DailyForecast> _forecast = [];
  List<HourlyForecast> _hourlyForecast = [];
  List<String> _favourites = [];
  List<String> _alerts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRegion = 'All';

  Weather? get currentWeather => _currentWeather;
  List<DailyForecast> get forecast => _forecast;
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;
  List<String> get favourites => _favourites;
  List<String> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedRegion => _selectedRegion;

  void setSettingsProvider(SettingsProvider provider) {
    _settingsProvider = provider;
  }

  Future<void> init() async {
    _loadFavourites();
    // Try to load weather immediately with fallback
    try {
      await fetchWeatherByLocation();
    } catch (e) {
      // If location fails, load default city immediately
      debugPrint('Location failed, loading default city: $e');
      await fetchWeatherByCity('London');
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    }
  }


  Future<void> fetchWeatherByLocation() async {
    try {
      _setLoading(true);
      _errorMessage = null;
      
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        // Fallback to default city immediately
        debugPrint('Location permission denied, using default city');
        await fetchWeatherByCity('London');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 5), // Reduced from 10 to 5 seconds
        onTimeout: () {
          debugPrint('Location timeout (5s), using default city');
          throw Exception('Location timeout');
        },
      );
      
      final units = _settingsProvider?.unitSystem ?? 'metric';
      final weather = await _apiService.getWeatherByLocation(
        position.latitude,
        position.longitude,
        units: units,
      );
      _currentWeather = weather;
      await _loadForecastAndAlerts(position.latitude, position.longitude);
      _errorMessage = null;
    } catch (e) {
      debugPrint('Error fetching weather by location: $e');
      // Fallback to default city on error
      try {
        _errorMessage = null;
        await fetchWeatherByCity('London');
      } catch (fallbackError) {
        _errorMessage = 'Could not load weather data. Please check your internet connection.';
        debugPrint('Fallback error: $fallbackError');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      
      final units = _settingsProvider?.unitSystem ?? 'metric';
      final weather = await _apiService.getWeatherByCity(city, units: units);
      _currentWeather = weather;
      
      // Use the city's coordinates from the weather response for forecast
      await _loadForecastAndAlerts(weather.latitude, weather.longitude);
      
      _errorMessage = null;
      debugPrint('Weather loaded for city: $city at ${weather.latitude}, ${weather.longitude}');
    } catch (e) {
      _errorMessage = 'City not found or network error';
      debugPrint('Error fetching weather for city $city: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadForecastAndAlerts(double lat, double lon) async {
    final units = _settingsProvider?.unitSystem ?? 'metric';
    _forecast = await _apiService.getSevenDayForecast(lat, lon, units: units);
    _hourlyForecast = await _apiService.getHourlyForecast(lat, lon, units: units);
    _alerts = await _apiService.getWeatherAlerts(lat, lon);
    notifyListeners();
  }

  void _loadFavourites() {
    final box = Hive.box<String>('favourites');
    _favourites = box.values.toList();
    notifyListeners();
  }

  void addFavourite(String city) {
    final box = Hive.box<String>('favourites');
    if (!_favourites.contains(city)) {
      box.add(city);
      _favourites.add(city);
      notifyListeners();
    }
  }

  void removeFavourite(int index) {
    final box = Hive.box<String>('favourites');
    box.deleteAt(index);
    _favourites.removeAt(index);
    notifyListeners();
  }

  void setRegionFilter(String region) {
    _selectedRegion = region;
    notifyListeners();
  }

  List<String> getFilteredFavourites() {
    if (_selectedRegion == 'All') return _favourites;
    // Simple demo filter based on string suffix like ", Europe"
    return _favourites.where((city) => city.endsWith(_selectedRegion)).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
