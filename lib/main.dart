import 'package:flutter/material.dart';
import 'package:test_app/pages/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(98, 2, 238, 1),
        ),
        primaryColor: Color.fromRGBO(181, 201, 253, 1),
      ),
      color: Color.fromRGBO(181, 201, 253, 1),
      home: MainPage(),
    );
  }
}
