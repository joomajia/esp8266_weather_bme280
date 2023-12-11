import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:esp8266dan/main.dart';
import 'package:flutter/material.dart';

class HumidityPage extends StatelessWidget {
  final List<HumidityData> humidityData;

  const HumidityPage({Key? key, required this.humidityData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Humidity Page'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          color: Colors.white60, // Светлый фон Card
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildHumidityChart(),
          ),
        ),
      ),
    );
  }

  Widget _buildHumidityChart() {
    return humidityData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : LineChart(
            _createHumiditySeries(),
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
                desiredTickCount: 12, // Увеличенное количество делений
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

  List<charts.Series<HumidityData, int>> _createHumiditySeries() {
    List<HumidityData> last8Data = humidityData.length > 8
        ? humidityData.sublist(humidityData.length - 8)
        : humidityData;

    return [
      charts.Series<HumidityData, int>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HumidityData data, _) => data.timestamp,
        measureFn: (HumidityData data, _) => data.humidity,
        data: last8Data,
      ),
    ];
  }
}
