import 'package:flutter/material.dart';

class Waves extends StatelessWidget {
  String waves;
  String minSpeed;
  String maxSpeed;
  String mentalState;
  String image;
  String text;
  Waves(
      {required this.waves,
      required this.minSpeed,
      required this.maxSpeed,
      required this.mentalState,
      required this.image,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${waves}',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 5),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Frequency Band : ${waves}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Speed (Hz) : ${minSpeed}  -  ${maxSpeed}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Mental State : ${mentalState}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(image),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
