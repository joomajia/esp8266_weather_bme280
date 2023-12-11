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
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  controller: ipAddressController,
                  decoration: InputDecoration(
                    labelText: 'Arduino IP Address',
                    hintText: 'Введите IP Address',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 47, 46, 46), 
                    ),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 31, 30, 30), 
                    ),
                  ),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 22, 22), // Белый цвет для введенного текста
                  ),
                ),
              ),
              trailing: ElevatedButton(
                onPressed: saveIpAddress,
                style: ElevatedButton.styleFrom(
                  primary:
                      Colors.grey[800], // Темный серый цвет для фона кнопки
                  onPrimary: Colors.white, // Белый цвет для текста кнопки
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Отступы внутри кнопки
                  minimumSize: Size(100.0,
                      36.0), // Минимальные размеры кнопки (ширина x высота)
                ),
                child: Text(
                  'Сохранить',
                  style: TextStyle(
                    fontSize: 14.0, // Размер шрифта текста кнопки
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // ListTile(
            //   title: TextField(
            //     controller: ipAddressController,
            //     decoration: InputDecoration(
            //       labelText: 'Arduino IP Address',
            //       hintText: 'Введите IP Address',
            //     ),
            //   ),
            //   trailing: ElevatedButton(
            //     onPressed: saveIpAddress,
            //     child: Text('Сохранить'),
            //   ),
            // ),
            ElevatedButton(
              onPressed: startMeasurements,
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800],
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                minimumSize: Size(200.0, 48.0),
              ),
              child: Text(
                'Начать измерения',
                style: TextStyle(
                  fontSize: 16.0, // Размер шрифта текста кнопки
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // ElevatedButton(
            //   onPressed: startMeasurements,
            //   child: const Text('Начать измерения'),
            // ),
            ElevatedButton(
              onPressed: stopMeasurements,
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800],
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                minimumSize: Size(200.0, 48.0),
              ),
              child: Text(
                'Остановить',
                style: TextStyle(
                  fontSize: 16.0, // Размер шрифта текста кнопки
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // ElevatedButton(
            //   onPressed: stopMeasurements,
            //   child: const Text('Остановить'),
            // ),
            ElevatedButton(
              onPressed: takeImmediateMeasurement,
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800],
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0), 
                minimumSize: Size(200.0,
                    48.0), 
              ),
              child: Text(
                'Получить данные',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              color: const Color.fromARGB(
                  255, 164, 163, 163),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  'Данные с датчика:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0, 
                  ),
                ),
                subtitle: Text(
                  immediateMeasurementResult,
                  style: TextStyle(
                    color: Colors.white, 
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
