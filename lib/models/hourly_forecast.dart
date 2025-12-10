class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String iconCode;
  final String description;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
    required this.description,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['temp'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }

  get condition => null;

  get icon => null;
}
