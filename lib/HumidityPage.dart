import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:esp8266dan/main.dart';
import 'package:flutter/material.dart';

class HumidityPage extends StatelessWidget {
  final List<HumidityData> humidityData;

  const HumidityPage({super.key, required this.humidityData});

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: humidityData.isEmpty
                ? const CircularProgressIndicator()
                : LineChart(
                    _createHumiditySeries(),
                    animate: true,
                  ),
          ),
        ),
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