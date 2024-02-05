import 'dart:async';
import 'dart:math';
import 'package:eeg_signal/app_color.dart';
import 'package:eeg_signal/utils/constant_images.dart';
import 'package:eeg_signal/utils/constant_mentalState.dart';
import 'package:eeg_signal/utils/constant_text.dart';
import 'package:eeg_signal/utils/wave.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: AppColors.mainTextColor3,
              ),
        ),
        scaffoldBackgroundColor: AppColors.pageBackground,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'EEG Signal',
            style: TextStyle(
              letterSpacing: 5,
            ),
          ),
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
  double frequency = 0;
  final int duration = 10;
  final int numberOfPoints = 100;

  late List<double> time;
  late List<double> eegSignal;

  @override
  void initState() {
    super.initState();

    frequency = 0.5;

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
          Text(
            'Frequency (Hz): ${frequency.toStringAsFixed(1)}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 5),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: getWidget(frequency),
          ),
          Slider(
            value: frequency,
            min: 0.5,
            max: 50,
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
                maxX: frequency < 50 ? 1.5 * frequency.toDouble() : 60,
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

  Widget getWidget(double value) {
    if (value >= 0.5 && value < 4.0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Delta Waves',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Waves(
                      waves: "Delta Waves",
                      minSpeed: "0.5",
                      maxSpeed: "4.0",
                      mentalState: MentalState.delta,
                      image: Images.deltaWave,
                      text: WaveText.deltaString,
                    ),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      );
    } else if (value >= 4 && value < 8.0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Theta Waves',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Waves(
                      waves: "Theta Waves",
                      minSpeed: "4.0",
                      maxSpeed: "8.0",
                      mentalState: MentalState.theta,
                      image: Images.thetaWave,
                      text: WaveText.thetaString,
                    ),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      );
    } else if (value >= 8 && value < 12.0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alpha Waves',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Waves(
                      waves: "Alpha Waves",
                      minSpeed: "8.0",
                      maxSpeed: "12.0",
                      mentalState: MentalState.alpha,
                      image: Images.alphaWave,
                      text: WaveText.alphaString,
                    ),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      );
    } else if (value >= 12.0 && value < 30.0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Beta Waves',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Waves(
                      waves: "Beta Waves",
                      minSpeed: "12.0",
                      maxSpeed: "30.0",
                      mentalState: MentalState.beta,
                      image: Images.betaWave,
                      text: WaveText.betaString,
                    ),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Gamma Waves',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Waves(
                      waves: "Gamma Waves",
                      minSpeed: "30.0",
                      maxSpeed: "100.0",
                      mentalState: MentalState.gamma,
                      image: Images.gammaWave,
                      text: WaveText.gammaString,
                    ),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      );
    }
  }
}
