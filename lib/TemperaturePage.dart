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
        title: const Text('Pressure Page'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          color: Colors.white60, // Светлый фон Card
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTempChart(),
          ),
        ),
      ),
    );
  }

  Widget _buildTempChart() {
    return temperatureData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : LineChart(
            _createTemperatureSeries(),
            // animate: true,
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.MaterialPalette.black,
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: 2, // Толщина линии сетки
                ),
              ),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredTickCount: 10, // Увеличенное количество делений
              ),
            ),
            domainAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.MaterialPalette.black,
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: 2, // Толщина линии сетки
                ),
              ),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredTickCount: 7, // Увеличенное количество делений
              ),
            ),
            defaultRenderer: charts.LineRendererConfig(
              strokeWidthPx: 4, // Увеличенная толщина линии показа данных
            ),
          );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Temperature Page'),
  //     ),
  //     body: Center(
  //       child: Card(
  //         elevation: 4,
  //         margin: const EdgeInsets.all(16),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: temperatureData.isEmpty
  //               ? const CircularProgressIndicator()
  //               : LineChart(
  //                   _createTemperatureSeries(),
  //                   animate: true,
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
