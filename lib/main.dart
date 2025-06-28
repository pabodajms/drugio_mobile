import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DrugioApp());
}

class DrugioApp extends StatelessWidget {
  const DrugioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drugio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
