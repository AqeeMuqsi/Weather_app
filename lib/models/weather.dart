class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final String icon;
  final double latitude;
  final double longitude;
  final DateTime sunrise;
  final DateTime sunset;
  final int pressure;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.icon,
    required this.latitude,
    required this.longitude,
    required this.sunrise,
    required this.sunset,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] ?? 0,
      icon: json['weather'][0]['icon'] ?? '01d',
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch((json['sys']['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((json['sys']['sunset'] ?? 0) * 1000),
      pressure: json['main']['pressure'] ?? 0,
    );
  }
}
