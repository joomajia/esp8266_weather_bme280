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
          color: Colors.white60, // Светлый фон Card
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPressureChart(),
          ),
        ),
      ),
    );
  }

  Widget _buildPressureChart() {
    return pressureData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : LineChart(
            _createPressureSeries(),
            animate: true,
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
  //       title: const Text('Pressure Page'),
  //     ),
  //     body: Center(
  //       child: Card(
  //         elevation: 4,
  //         margin: const EdgeInsets.all(16),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: pressureData.isEmpty
  //               ? const CircularProgressIndicator()
  //               : LineChart(
  //                   _createPressureSeries(),
  //                   animate: true,
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
