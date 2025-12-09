import 'package:flutter_test/flutter_test.dart';
import 'package:skywatch/models/weather.dart';
import 'package:skywatch/models/daily_forecast.dart';
import 'package:skywatch/models/hourly_forecast.dart';

void main() {
  group('Weather Model Tests', () {
    test('Weather.fromJson should parse valid JSON correctly', () {
      final json = {
        'name': 'London',
        'main': {
          'temp': 20.5,
          'feels_like': 19.0,
          'humidity': 65,
          'pressure': 1013,
        },
        'weather': [
          {
            'main': 'Clear',
            'icon': '01d',
          }
        ],
        'wind': {
          'speed': 5.5,
          'deg': 180,
        },
        'coord': {
          'lat': 51.5074,
          'lon': -0.1278,
        },
        'sys': {
          'sunrise': 1609477200,
          'sunset': 1609513200,
        }
      };

      final weather = Weather.fromJson(json);

      expect(weather.cityName, 'London');
      expect(weather.temperature, 20.5);
      expect(weather.feelsLike, 19.0);
      expect(weather.condition, 'Clear');
      expect(weather.humidity, 65);
      expect(weather.windSpeed, 5.5);
      expect(weather.windDegree, 180);
      expect(weather.icon, '01d');
      expect(weather.latitude, 51.5074);
      expect(weather.longitude, -0.1278);
      expect(weather.pressure, 1013);
    });

    test('Weather.fromJson should handle missing optional fields', () {
      final json = {
        'name': '',
        'main': {
          'temp': 15,
          'feels_like': 14,
          'humidity': 0,
          'pressure': 0,
        },
        'weather': [
          {
            'main': '',
            'icon': '01d',
          }
        ],
        'wind': {
          'speed': 0,
          'deg': 0,
        },
        'coord': {
          'lat': 0,
          'lon': 0,
        },
        'sys': {
          'sunrise': 0,
          'sunset': 0,
        }
      };

      final weather = Weather.fromJson(json);

      expect(weather.cityName, '');
      expect(weather.temperature, 15);
      expect(weather.humidity, 0);
      expect(weather.windDegree, 0);
    });
  });

  group('DailyForecast Model Tests', () {
    test('DailyForecast.fromJson should parse valid JSON correctly', () {
      final json = {
        'dt': 1609477200,
        'temp': {
          'min': 10.0,
          'max': 25.0,
        },
        'weather': [
          {
            'main': 'Clouds',
            'icon': '02d',
          }
        ],
      };

      final forecast = DailyForecast.fromJson(json);

      expect(forecast.date, DateTime.fromMillisecondsSinceEpoch(1609477200 * 1000));
      expect(forecast.minTemp, 10.0);
      expect(forecast.maxTemp, 25.0);
      expect(forecast.condition, 'Clouds');
      expect(forecast.icon, '02d');
    });
  });

  group('HourlyForecast Model Tests', () {
    test('HourlyForecast.fromJson should parse valid JSON correctly', () {
      final json = {
        'dt': 1609477200,
        'temp': 18.5,
        'weather': [
          {
            'main': 'Rain',
            'icon': '10d',
          }
        ],
      };

      final forecast = HourlyForecast.fromJson(json);

      expect(forecast.time, DateTime.fromMillisecondsSinceEpoch(1609477200 * 1000));
      expect(forecast.temperature, 18.5);
      expect(forecast.condition, 'Rain');
      expect(forecast.icon, '10d');
    });
  });
}
