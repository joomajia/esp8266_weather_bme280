import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:esp8266dan/main.dart';
import 'package:flutter/material.dart';

class TemperaturePage extends StatelessWidget {
  final List<TemperatureData> temperatureData;

  const TemperaturePage({super.key, required this.temperatureData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Page'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: temperatureData.isEmpty
                ? const CircularProgressIndicator()
                : LineChart(
                    _createTemperatureSeries(),
                    animate: true,
                  ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<TemperatureData, int>> _createTemperatureSeries() {
    List<TemperatureData> last8Data = temperatureData.length > 8
        ? temperatureData.sublist(temperatureData.length - 8)
        : temperatureData;

    return [
      charts.Series<TemperatureData, int>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TemperatureData data, _) => data.timestamp,
        measureFn: (TemperatureData data, _) => data.temperature,
        data: last8Data,
      ),
    ];
  }
}