import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pi_app/app/views/home_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor customWhiteColor = const MaterialColor(0xFFFFFFFF, {
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    });
    return MaterialApp(
        title: 'PI App',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          primarySwatch: customWhiteColor,
          brightness: Brightness.dark,
        ),
        home: const HomePage());
  }
}
