import 'package:flutter/material.dart';

class SummerhackApp extends StatelessWidget {
  const SummerhackApp({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text('Summerhack Phase 0 scaffold')),
      ),
    );
  }
}
