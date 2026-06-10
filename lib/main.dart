import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const SmartGardenApp());
}

class SmartGardenApp extends StatelessWidget {
  const SmartGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartGarden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF2F6F2),
      ),
      home: const LoginPage(),
    );
  }
}
