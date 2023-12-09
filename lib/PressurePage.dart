import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:esp8266dan/main.dart';
import 'package:flutter/material.dart';

class PressurePage extends StatelessWidget {
  final List<PressureData> pressureData;

  const PressurePage({super.key, required this.pressureData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pressure Page'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: pressureData.isEmpty
                ? const CircularProgressIndicator()
                : LineChart(
                    _createPressureSeries(),
                    animate: true,
                  ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<PressureData, int>> _createPressureSeries() {
    List<PressureData> last8Data = pressureData.length > 8
        ? pressureData.sublist(pressureData.length - 8)
        : pressureData;

    return [
      charts.Series<PressureData, int>(
        id: 'Pressure',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PressureData data, _) => data.timestamp,
        measureFn: (PressureData data, _) => data.pressure,
        data: last8Data,
      ),
    ];
  }
}