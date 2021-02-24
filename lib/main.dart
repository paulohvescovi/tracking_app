import 'package:flutter/material.dart';
import 'package:tracking_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rastreador de Encomendas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
