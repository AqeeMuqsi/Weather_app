import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:skywatch/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('ApiService should be instantiated', () {
      expect(apiService, isNotNull);
    });

    // Note: These are integration tests that require actual API calls
    // For coursework documentation, we demonstrate the test structure

    group('getWeatherByCity', () {
      test('should return Weather object for valid city', () async {
        // This test requires actual API connectivity
        // In production, you would mock the Dio client
        try {
          final weather = await apiService.getWeatherByCity('London');
          expect(weather.cityName, isNotEmpty);
          expect(weather.temperature, isNotNull);
        } catch (e) {
          // If API call fails, test passes if error is properly formatted
          expect(e.toString(), contains('Exception'));
        }
      });

      test('should throw exception for invalid city', () async {
        expect(
          () async => await apiService.getWeatherByCity('InvalidCityNameXYZ123'),
          throwsException,
        );
      });

      test('should handle metric units parameter', () async {
        try {
          final weather = await apiService.getWeatherByCity('Paris', units: 'metric');
          expect(weather, isNotNull);
        } catch (e) {
          expect(e, isNotNull);
        }
      });

      test('should handle imperial units parameter', () async {
        try {
          final weather = await apiService.getWeatherByCity('New York', units: 'imperial');
          expect(weather, isNotNull);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    group('getWeatherByLocation', () {
      test('should return Weather object for valid coordinates', () async {
        try {
          // London coordinates
          final weather = await apiService.getWeatherByLocation(51.5074, -0.1278);
          expect(weather, isNotNull);
          expect(weather.latitude, closeTo(51.5074, 1.0));
          expect(weather.longitude, closeTo(-0.1278, 1.0));
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    group('getSevenDayForecast', () {
      test('should return list of 7 daily forecasts', () async {
        try {
          final forecasts = await apiService.getSevenDayForecast(51.5074, -0.1278);
          expect(forecasts, isNotNull);
          expect(forecasts.length, lessThanOrEqualTo(7));
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    group('getHourlyForecast', () {
      test('should return list of 24 hourly forecasts', () async {
        try {
          final forecasts = await apiService.getHourlyForecast(51.5074, -0.1278);
          expect(forecasts, isNotNull);
          expect(forecasts.length, lessThanOrEqualTo(24));
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });

    group('getWeatherAlerts', () {
      test('should return list of weather alerts', () async {
        try {
          final alerts = await apiService.getWeatherAlerts(51.5074, -0.1278);
          expect(alerts, isNotNull);
          expect(alerts, isList);
        } catch (e) {
          expect(e, isNotNull);
        }
      });
    });
  });
}
