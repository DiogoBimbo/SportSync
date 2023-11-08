import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'amigos_inicial_screen.dart';
import 'package:pi_app/app/styles/styles.dart';

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
        children: [
          FlutterLogin(
            logo: const AssetImage('assets/images/logo.jpg'),
            onLogin: _authUser,
            onSignup: _signupUser,
            onSubmitAnimationCompleted: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AmigosInicialScreen()),
                (route) => false,
              );
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
              accentColor: Styles.corPrincipal,
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
              buttonTheme: const LoginButtonTheme(
                backgroundColor: Styles.corPrincipal,
              ),
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
                  borderRadius: Styles.inputBorderLogin,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: Styles.inputBorderLogin,
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
