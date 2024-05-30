import 'package:flutter/material.dart';

class RateApp extends StatelessWidget {
  const RateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Rate App",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.purpleAccent,
          ),
          body: Center(
            child: const Text('Coming Up..'),
          )),
    );
  }
}
