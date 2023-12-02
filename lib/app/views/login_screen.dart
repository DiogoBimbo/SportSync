import 'dart:math';
import 'package:pi_app/app/components/imagens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/app/views/home_screen.dart';
import 'amigos_inicial_screen.dart';
import 'package:pi_app/app/styles/styles.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool isSigningUp = false;

  Future<String?> _authUser(LoginData data) async {
    isSigningUp = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      // Sucesso: retorna null
      return null;
    } on FirebaseAuthException catch (e) {
      // Falha: retorna a mensagem de erro
      return e.message;
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    isSigningUp = true;
    try {
      // Criação da conta do usuário
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      // Extrair nome do usuário a partir do e-mail
      String userName = data.name!.split('@').first;

      // Selecionar uma foto aleatória de um conjunto de fotos
      List<String> photoList = [
        ImagensUsers.userImg1,
        ImagensUsers.userImg2,
        ImagensUsers.userImg3,
        ImagensUsers.userImg4,
        ImagensUsers.userImg5,
        ImagensUsers.userImg6,
        ImagensUsers.userImg7,
        ImagensUsers.userImg8,
        ImagensUsers.userImg9,
        ImagensUsers.userImg10
      ];
      Random random = Random();
      String randomPhoto = photoList[random.nextInt(photoList.length)];

      // Salvar informações adicionais no Firestore
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userName,
        'photo': randomPhoto,
      });

      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // Falha
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      // Se o email for enviado com sucesso, retornamos null, indicando que não houve erro.
      return null;
    } on FirebaseAuthException catch (e) {
      // Se houver um erro, retornamos a mensagem de erro.
      return e.message;
    }
  }

  Duration get loginTime => const Duration(milliseconds: 2250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterLogin(
            logo: const AssetImage('assets/images/ss.png'),
            onLogin: _authUser,
            onSignup: _signupUser,
            onSubmitAnimationCompleted: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => isSigningUp
                      ? const AmigosInicialScreen()
                      : const GeralScreen(),
                ),
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
              forgotPasswordButton: 'Esqueci minha senha',
              recoverPasswordButton: 'RECUPERAR',
              goBackButton: 'VOLTAR',
              confirmPasswordError: 'Não corresponde!',
              recoverPasswordIntro: 'Recupere sua senha aqui',
              recoverPasswordDescription:
                  'Nós enviaremos sua senha em texto para esta conta de email',
              recoverPasswordSuccess: 'Email de alteração de senha enviado!',
            ),
            theme: LoginTheme(
              accentColor: Styles.corPrincipal,
              errorColor: Colors.red[400],
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
