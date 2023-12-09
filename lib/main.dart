import 'dart:async';
import 'package:esp8266dan/HomePage.dart';
import 'package:esp8266dan/HumidityPage.dart';
import 'package:esp8266dan/PressurePage.dart';
import 'package:esp8266dan/TemperaturePage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;


void main() {
  runApp(MyApp());
}

class TemperatureData {
  final int timestamp;
  final double temperature;

  TemperatureData(this.timestamp, this.temperature);
}

class HumidityData {
  final int timestamp;
  final double humidity;

  HumidityData(this.timestamp, this.humidity);
}

class PressureData {
  final int timestamp;
  final double pressure;

  PressureData(this.timestamp, this.pressure);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin<MyHomePage> {
  List<TemperatureData> temperatureData = [];
  List<HumidityData> humidityData = [];
  List<PressureData> pressureData = [];

  int _currentIndex = 0;

  final List<Widget> pages = [
    const TemperaturePage(
      temperatureData: [],
    ),
    Container(color: Colors.cyan),
    Container(color: Colors.orange),
    Container(color: Colors.blue),
  ];

  @override
  void initState() {
    super.initState();
    fetchDataTemp();
    fetchDataHumid();
    fetchDataPressure();
  }

  bool isConnected = false;

  void setConnectionStatus(bool status) {
    setState(() {
      isConnected = status;
    });
  }

  Future<void> fetchTemperatureDataWithRetry() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await fetchDataTemp();
        break;
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        } else {
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
        }
      }
    }
  }

  Future<void> fetchDataTemp() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .get(Uri.parse('http://${globals.arduinoIpAddress}:80/getFileTempBME280'));

        if (response.statusCode == 200) {
          setState(() {
            setConnectionStatus(true);
            temperatureData = parseTemperatureData(response.body);
          });
          break; // Exit the loop if fetching is successful
        } else {
          throw Exception(
              'Failed to load temperature data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(
              Duration(seconds: 5)); // Delay before the next retry
        } else {
          // Handle the error after all retries are exhausted
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
          // You might want to throw an exception or perform other actions here
        }
      }
    }
  }

  Future<void> fetchHumidDataWithRetry() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await fetchDataHumid();
        break;
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        } else {
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
        }
      }
    }
  }

  Future<void> fetchDataHumid() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .get(Uri.parse('http://${globals.arduinoIpAddress}:80/getFileHumidBME280'));

        if (response.statusCode == 200) {
          setState(() {
            humidityData = parseHumidityData(response.body);
          });
          break; // Exit the loop if fetching is successful
        } else {
          throw Exception(
              'Failed to load temperature data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        } else {
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
        }
      }
    }
  }

  Future<void> fetchPressureDataWithRetry() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await fetchDataPressure();
        break;
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        } else {
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
        }
      }
    }
  }

  Future<void> fetchDataPressure() async {
    const maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .get(Uri.parse('http://${globals.arduinoIpAddress}:80/getFilePressBME280'));

        if (response.statusCode == 200) {
          setState(() {
            pressureData = parsePressureData(response.body);
          });
          break; // Exit the loop if fetching is successful
        } else {
          throw Exception(
              'Failed to load temperature data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching temperature data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        } else {
          print(
              'Failed after $maxRetries retries. Please check your network connection.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Датчик'),
        actions: [
          Icon(
            isConnected ? Icons.check : Icons.clear,
            color: isConnected ? Colors.green : Colors.red,
          ),
          SizedBox(width: 16.0),
        ],
      ),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // You can add logic here to navigate to different pages based on the index
          // For example:
          // if (index == 1) {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPage()));
          // }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq, color: Colors.black),
            label: 'Temperature',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_sharp, color: Colors.black),
            label: 'Humidity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_outlined, color: Colors.black),
            label: 'Pressure',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return FirstPage();
      case 1:
        return TemperaturePage(temperatureData: temperatureData);
      case 2:
        return HumidityPage(humidityData: humidityData);
      case 3:
        return PressurePage(
          pressureData: pressureData,
        );
      default:
        return Center(
          child: Text('Invalid Page'),
        );
    }
  }

  List<TemperatureData> parseTemperatureData(String responseBody) {
    List<TemperatureData> data = [];
    List<String> lines = LineSplitter.split(responseBody).toList();
    for (String line in lines) {
      List<String> parts = line.split(' ');
      if (parts.length == 2) {
        int timestamp = int.parse(parts[0]);
        double temperature = double.parse(parts[1]);
        data.add(TemperatureData(timestamp, temperature));
      }
    }
    return data;
  }

  List<HumidityData> parseHumidityData(String responseBody) {
    List<HumidityData> data = [];
    List<String> lines = LineSplitter.split(responseBody).toList();
    for (String line in lines) {
      List<String> parts = line.split(' ');
      if (parts.length == 2) {
        int timestamp = int.parse(parts[0]);
        double humidity = double.parse(parts[1]);
        data.add(HumidityData(timestamp, humidity));
      }
    }
    return data;
  }

  List<PressureData> parsePressureData(String responseBody) {
    List<PressureData> data = [];
    List<String> lines = LineSplitter.split(responseBody).toList();
    for (String line in lines) {
      List<String> parts = line.split(' ');
      if (parts.length == 2) {
        int timestamp = int.parse(parts[0]);
        double pressure = double.parse(parts[1]);
        data.add(PressureData(timestamp, pressure));
      }
    }
    return data;
  }
}
