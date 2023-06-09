import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Velocity Vision',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Velocity Vision'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _gaugeColor = Colors.blue;
  Color _themeColor = Colors.blue;
  double _speed = 0;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _timer;
  
  get math => null;

  double _latitude = 37.7749;
  double _longitude = -122.4194;

  bool _useCustomerColors = false;
  List<double> _alertSpeeds = [90, 120, 180];
  List<Color> _alertColors = [Color.fromARGB(255, 0, 255, 55), Color.fromARGB(255, 255, 204, 0), Colors.red];

  Color _primaryColor = Colors.blue;
  Color _accentColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();

    // Request permission to access the device's location
    Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.always || value == LocationPermission.whileInUse) {
        // Start listening to location updates
        _positionStreamSubscription = Geolocator.getPositionStream().listen((position) {
          // Calculate the speed based on the latest two positions
          if (_positionStreamSubscription != null && position != null && _lastPosition != null) {
            final timeDifference = position.timestamp!.difference(_lastPosition!.timestamp!).inSeconds;
            final distance = Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            _speed = distance / timeDifference;
            setState(() {}); // Rebuild the widget tree to update the speed display
          }
          _lastPosition = position;
        }, onError: (error) {
          print("Error: $error");
        });
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      // Stop listening to location updates
      _positionStreamSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title!),
        bottom: TabBar(
          tabs: [
            Tab(text: "Speedometer"),
            Tab(text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 400,
                  height: 400,
                  padding: EdgeInsets.all(10),
                  child: KdGaugeView(
                    minSpeed: 0,
                    maxSpeed: 260,
                    speed: _speed,
                    animate: true,
                    duration: Duration(seconds: 5),
                    alertSpeedArray: [90, 120, 180],
                    alertColorArray: [Color.fromARGB(255, 0, 255, 55), Color.fromARGB(255, 255, 204, 0), Colors.red],
                    unitOfMeasurement: "km/h",
                    gaugeWidth: 20,
                    fractionDigits: 1,
                    speedTextStyle: TextStyle(
                      color: _gaugeColor,
                      fontSize: 50,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Latitude: ${_lastPosition?.latitude ?? _latitude}"),
                Text("Longitude: ${_lastPosition?.longitude ?? _longitude}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gauge color"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _gaugeColor = Colors.blue;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _gaugeColor = Colors.red;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _gaugeColor = Colors.green;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Theme color"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _themeColor = Colors.blue;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _themeColor = Colors.red;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _themeColor = Colors.green;
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
