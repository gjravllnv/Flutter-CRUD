import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 1, 17, 27),
    fontFamily: 'Georgia',textTheme: const TextTheme(
    ),
  ),
      home: LoginPage(),
      // LoginPage(),
      // 
    );
  }
}

