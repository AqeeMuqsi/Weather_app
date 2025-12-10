class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;

  DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      minTemp: (json['temp']['min'] as num).toDouble(),
      maxTemp: (json['temp']['max'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
    );
  }

  get icon => null;
}
