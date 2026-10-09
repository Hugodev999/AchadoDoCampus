import 'package:flutter/material.dart';
import 'auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Achados do Campus',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthPage(),
    );
  }
}
