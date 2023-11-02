import 'package:flutter/material.dart';

class GruposScreen extends StatelessWidget {
  const GruposScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Grupo 1'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Grupo 2'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Grupo 3'),
          ),
          // Adicione mais elementos de acordo com as necessidades
        ],
      ),
    );
  }
}
