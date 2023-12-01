import 'package:flutter/material.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/app/views/home_screen.dart';
import 'package:pi_app/services/auth_service.dart';
import 'package:provider/provider.dart';


class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck>{
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    
    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const HomePage();
    } else {
      return const GeralScreen();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}