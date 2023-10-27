// tela que será exibida após o login !!!!TEMPORÁRIO!!!!
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Bem-vindo ao Painel!'),
      ),
    );
  }
}
