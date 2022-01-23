import 'package:flutter/material.dart';
import 'package:isaafoukom/Welcome/welcome_screen.dart';

String APIA = "http://192.168.8.112:5000/";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
