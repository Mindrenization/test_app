import 'package:flutter/material.dart';
import 'package:test_app/pages/tasks_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF6202EE),
        ),
        primaryColor: const Color.fromRGBO(181, 201, 253, 1),
      ),
      home: TasksPage(),
    );
  }
}
