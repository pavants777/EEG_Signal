import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('EEG Signal'),
          centerTitle: true,
        ),
        body: AnimatedEEGSignal(),
      ),
    );
  }
}

class AnimatedEEGSignal extends StatefulWidget {
  @override
  _AnimatedEEGSignalState createState() => _AnimatedEEGSignalState();
}

class _AnimatedEEGSignalState extends State<AnimatedEEGSignal> {
  List<double> eegSignalData = List.generate(100, (index) => 0.0);
  double frequency = 1;
  final int duration = 10; // seconds
  final int numberOfPoints = 100;

  late List<double> time;
  late List<double> eegSignal;

  @override
  void initState() {
    super.initState();

    time = List.generate(numberOfPoints,
        (index) => index * duration / numberOfPoints.toDouble());
    eegSignal = generateEEGSignal(time);

    startSignalAnimation();
  }

  void startSignalAnimation() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      updateEEGSignalData();
    });
  }

  void updateEEGSignalData() {
    setState(() {
      eegSignalData.removeAt(0);
      eegSignalData.add(generateRandomValue());
    });
  }

  double generateRandomValue() {
    double newFrequency = frequency + Random().nextDouble() * 10 - 5;
    return sin(2 * pi * newFrequency * eegSignalData.length / 100.0) +
        0.5 * Random().nextDouble();
  }

  List<double> generateEEGSignal(List<double> time) {
    final double frequency = 5;

    return List.generate(time.length, (index) {
      return sin(2 * pi * frequency * time[index]) +
          0.5 * Random().nextDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Frequency (Hz): $frequency'),
          Slider(
            value: frequency,
            min: 1,
            max: 100,
            onChanged: (value) {
              setState(() {
                frequency = value;
              });
            },
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: frequency.toDouble(),
                minY: -1.5,
                maxY: 2,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      eegSignalData.length,
                      (index) => FlSpot(index.toDouble(), eegSignalData[index]),
                    ),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
