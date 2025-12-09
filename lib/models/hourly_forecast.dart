class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String iconCode;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['temp'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}
