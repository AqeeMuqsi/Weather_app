import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/weather.dart';
import '../models/daily_forecast.dart';
import '../models/hourly_forecast.dart';

class ApiService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = '86302f72572ddfc3f9aea5d624a4bc52';

  final Dio _dio = Dio(BaseOptions(
    validateStatus: (status) => status != null && status < 500,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<Weather> getWeatherByCity(String city, {String units = 'metric'}) async {
    try {
      final response = await _dio.get('$_baseUrl/weather', queryParameters: {
        'q': city,
        'appid': _apiKey,
        'units': units,
      });
      
      if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenWeatherMap API key.');
      }
      
      if (response.statusCode == 404) {
        throw Exception('City not found');
      }
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
      
      return Weather.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Weather> getWeatherByLocation(double lat, double lon, {String units = 'metric'}) async {
    final response = await _dio.get('$_baseUrl/weather', queryParameters: {
      'lat': lat,
      'lon': lon,
      'appid': _apiKey,
      'units': units,
    });
    
    if (response.statusCode == 401) {
      throw Exception('Invalid API key. Please check your OpenWeatherMap API key.');
    }
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
    
    return Weather.fromJson(response.data);
  }

  Future<List<DailyForecast>> getSevenDayForecast(double lat, double lon, {String units = 'metric'}) async {
    try {
      // Use the free forecast endpoint instead of onecall (which requires subscription)
      final response = await _dio.get('$_baseUrl/forecast', queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': _apiKey,
        'units': units,
        'cnt': 40, // 5 days * 8 (3-hour intervals)
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch forecast: ${response.statusCode}');
      }

      final List forecastList = response.data['list'] ?? [];
      
      // Group forecasts by day
      Map<String, List<dynamic>> dailyGroups = {};
      for (var item in forecastList) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dateKey = '${date.year}-${date.month}-${date.day}';
        
        dailyGroups[dateKey] ??= [];
        dailyGroups[dateKey]!.add(item);
      }

      // Convert to daily forecasts
      List<DailyForecast> dailyForecasts = [];
      dailyGroups.forEach((dateKey, items) {
        if (dailyForecasts.length < 7) {
          // Calculate min/max temps for the day
          double minTemp = items.map((e) => (e['main']['temp_min'] as num).toDouble()).reduce((a, b) => a < b ? a : b);
          double maxTemp = items.map((e) => (e['main']['temp_max'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
          
          // Get the most common weather condition
          String condition = items[0]['weather'][0]['main'];
          
          // Get the date from first item
          DateTime date = DateTime.fromMillisecondsSinceEpoch(items[0]['dt'] * 1000);
          
          dailyForecasts.add(DailyForecast(
            date: date,
            minTemp: minTemp,
            maxTemp: maxTemp,
            condition: condition,
          ));
        }
      });

      return dailyForecasts.take(7).toList();
    } catch (e) {
      debugPrint('Error fetching 7-day forecast: $e');
      return [];
    }
  }

  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lon, {String units = 'metric'}) async {
    try {
      // Use the free forecast endpoint
      final response = await _dio.get('$_baseUrl/forecast', queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': _apiKey,
        'units': units,
        'cnt': 24, // Next 24 hours (8 data points for 3-hour intervals)
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch hourly forecast: ${response.statusCode}');
      }

      final List forecastList = response.data['list'] ?? [];
      
      return forecastList.take(8).map((item) {
        return HourlyForecast(
          time: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          temperature: (item['main']['temp'] as num).toDouble(),
          description: item['weather'][0]['main'],
          iconCode: item['weather'][0]['icon'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching hourly forecast: $e');
      return [];
    }
  }

  Future<List<String>> getWeatherAlerts(double lat, double lon) async {
    try {
      // One Call API requires subscription, so we'll return empty alerts for free tier
      // In production, you could use a different alert service or paid tier
      debugPrint('Weather alerts require One Call API subscription');
      return [];
    } catch (e) {
      debugPrint('Error fetching alerts: $e');
      return [];
    }
  }
}
