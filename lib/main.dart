import 'package:flutter/material.dart';
import 'package:graphic/RouteGenerator.dart';
import 'package:graphic/views/Login.dart';

void main() {
  runApp(MyApp());
}

final ThemeData defaultTheme = ThemeData(
  primaryColor: Colors.lightBlue[300],
  accentColor: Color(0xFF00cc8e),
);

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graphic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,

    );
  }
}