import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/daily_forecast.dart';

class TemperatureChart extends StatelessWidget {
  final List<DailyForecast> forecast;

  const TemperatureChart({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<DailyForecast, String>>[
          LineSeries<DailyForecast, String>(
            dataSource: forecast,
            xValueMapper: (DailyForecast f, _) =>
                '${f.date.day}/${f.date.month}',
            yValueMapper: (DailyForecast f, _) => f.maxTemp,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}
