import 'package:dio/dio.dart';

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
    final response = await _dio.get('$_baseUrl/onecall', queryParameters: {
      'lat': lat,
      'lon': lon,
      'exclude': 'minutely,hourly,current',
      'appid': _apiKey,
      'units': units,
    });

    final List list = response.data['daily'] ?? [];
    return list.take(7).map((e) => DailyForecast.fromJson(e)).toList();
  }

  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lon, {String units = 'metric'}) async {
    final response = await _dio.get('$_baseUrl/onecall', queryParameters: {
      'lat': lat,
      'lon': lon,
      'exclude': 'minutely,daily,current',
      'appid': _apiKey,
      'units': units,
    });

    final List list = response.data['hourly'] ?? [];
    return list.take(24).map((e) => HourlyForecast.fromJson(e)).toList();
  }

  Future<List<String>> getWeatherAlerts(double lat, double lon) async {
    final response = await _dio.get('$_baseUrl/onecall', queryParameters: {
      'lat': lat,
      'lon': lon,
      'exclude': 'minutely,hourly,current',
      'appid': _apiKey,
      'units': 'metric',
    });

    final List alerts = response.data['alerts'] ?? [];
    return alerts.map((e) => e['event']?.toString() ?? '').cast<String>().toList();
  }
}
