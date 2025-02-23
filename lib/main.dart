import 'package:flutter/material.dart';
import 'package:quiz_ai_bot/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizAIBot',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xfffa3c75),
        hintColor: const Color(0xfffa3c75),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfffa3c75),
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
