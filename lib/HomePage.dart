import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  String temperature = '';
  String humidity = '';
  String pressure = '';
  String immediateMeasurementResult = '';
  bool isConnected = false;

  TextEditingController ipAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ipAddressController.text = globals.arduinoIpAddress;
  }

  void startMeasurements() async {
    try {
      final response = await http.get(
          Uri.parse('http://${globals.arduinoIpAddress}:80/startMeasurements'));
      if (response.statusCode == 200) {
        fetchData();
        setConnectionStatus(true);
      } else {
        throw Exception('Failed to start measurements');
      }
    } catch (error) {
      print('Error starting measurements: $error');
    }
  }

  void stopMeasurements() async {
    try {
      final response = await http.get(
          Uri.parse('http://${globals.arduinoIpAddress}:80/stopMeasurements'));
      if (response.statusCode != 200) {
        throw Exception('Failed to stop measurements');
      }
    } catch (error) {
      print('Error stopping measurements: $error');
    } finally {
      setConnectionStatus(false);
    }
  }

  void takeImmediateMeasurement() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${globals.arduinoIpAddress}:80/takeImmediateMeasurement'));
      if (response.statusCode == 200) {
        setConnectionStatus(true);
        final data = response.body;
        setState(() {
          immediateMeasurementResult = data;
        });
      } else {
        throw Exception('Failed to take immediate measurement');
      }
    } catch (error) {
      print('Error taking immediate measurement: $error');
      // Handle error as needed
    }
  }

  void fetchData() async {
    try {
      final tempResponse = await http.get(
          Uri.parse('http://${globals.arduinoIpAddress}:80/getFileTempBME280'));
      final humidResponse = await http.get(Uri.parse(
          'http://${globals.arduinoIpAddress}:80/getFileHumidBME280'));
      final pressResponse = await http.get(Uri.parse(
          'http://${globals.arduinoIpAddress}:80/getFilePressBME280'));

      if (tempResponse.statusCode == 200 &&
          humidResponse.statusCode == 200 &&
          pressResponse.statusCode == 200) {
        setState(() {
          temperature = tempResponse.body;
          humidity = humidResponse.body;
          pressure = pressResponse.body;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void setConnectionStatus(bool status) {
    setState(() {
      isConnected = status;
    });
  }

  void saveIpAddress() {
    globals.arduinoIpAddress = ipAddressController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('IP Address сохранен: ${globals.arduinoIpAddress}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: TextField(
                controller: ipAddressController,
                decoration: InputDecoration(
                  labelText: 'Arduino IP Address',
                  hintText: 'Введите IP Address',
                ),
              ),
              trailing: ElevatedButton(
                onPressed: saveIpAddress,
                child: Text('Сохранить'),
              ),
            ),
            ElevatedButton(
              onPressed: startMeasurements,
              child: const Text('Начать измерения'),
            ),
            ElevatedButton(
              onPressed: stopMeasurements,
              child: const Text('Остановить'),
            ),
            ElevatedButton(
              onPressed: takeImmediateMeasurement,
              child: const Text('Получить данные'),
            ),
            Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Данные с датчика:\n $immediateMeasurementResult'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
