import 'package:flutter/material.dart';
import 'package:pi_app/app/views/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor customColor = MaterialColor(0xFF3427C2, {
      50: Color(0xFFE9E6F7),
      100: Color(0xFFC3BBF0),
      200: Color(0xFF9D93E9),
      300: Color(0xFF776AE2),
      400: Color(0xFF594FD7),
      500: Color(0xFF3427C2),
      600: Color(0xFF2E23B8),
      700: Color(0xFF271FAC),
      800: Color(0xFF211BA1),
      900: Color(0xFF181592),
    });
    return MaterialApp(
        title: 'PI App',
        theme: ThemeData(
          primarySwatch: customColor,
          brightness: Brightness.dark,
        ),
        home: const HomePage());
  }
}
