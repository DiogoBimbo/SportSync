import 'package:flutter/material.dart';
import 'package:pi_app/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PI App',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
        brightness: Brightness.dark
      ),
      home: const HomePage()
    );
  }
}
