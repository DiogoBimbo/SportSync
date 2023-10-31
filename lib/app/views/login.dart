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
    // Customizações do Login
    final corPrincipal = Color.fromARGB(255, 52, 39, 194);
    final inputBorder = BorderRadius.all(Radius.circular(50));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
            messages: LoginMessages(
              userHint: 'Email',
              passwordHint: 'Senha',
              confirmPasswordHint: 'Confirmar senha',
              loginButton: 'LOGIN',
              signupButton: 'CADASTRAR',
              forgotPasswordButton: 'Equeci minha senha',
              recoverPasswordButton: 'RECUPERAR',
              goBackButton: 'VOLTAR',
              confirmPasswordError: 'Não corresponde!',
              recoverPasswordIntro: 'Recupere sua senha aqui',
              recoverPasswordDescription:
                  'Nós enviaremos sua senha em texto para esta conta de email',
              recoverPasswordSuccess: 'Senha recuperada com sucesso!',
            ),
            theme: LoginTheme(
              accentColor: corPrincipal,
              errorColor: Colors.red,
              titleStyle: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'Inter',
              ),
              bodyStyle: const TextStyle(
                fontFamily: 'Inter',
              ),
              textFieldStyle: const TextStyle(
                fontFamily: 'Inter',
              ),
              buttonStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
              buttonTheme: LoginButtonTheme(
                backgroundColor: corPrincipal,
              ),
              // buttonStyle: const TextStyle(
              //   fontWeight: FontWeight.bold,
              // ),
              inputTheme: InputDecorationTheme(
                labelStyle: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  ),
                filled: true,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.0),
                  ),
                  borderRadius: inputBorder,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corPrincipal),
                  borderRadius: inputBorder,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
