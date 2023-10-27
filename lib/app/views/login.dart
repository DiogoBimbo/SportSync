import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard_screen.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return '';
    });
  }

  Future<String> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fundo_inicial.jpg',
            fit: BoxFit.cover,
          ),
          FlutterLogin(
            logo: const AssetImage('assets/images/logo.jpg'),
            onLogin: _authUser,
            onSignup: _signupUser,
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ));
            },
            onRecoverPassword: _recoverPassword,
            theme: LoginTheme(
              pageColorDark: Colors.black.withOpacity(0.0),
              primaryColor: const Color.fromARGB(255, 52, 39, 194),
              accentColor: Colors.yellow,
              errorColor: Colors.deepOrange,
              titleStyle: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
