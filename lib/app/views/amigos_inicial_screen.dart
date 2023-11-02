import 'package:flutter/material.dart';
import 'package:pi_app/app/views/grupos_screen.dart';

class AmigosInicialScreen extends StatefulWidget {
  const AmigosInicialScreen({Key? key}) : super(key: key);

  @override
  _AmigosInicialState createState() => _AmigosInicialState();
}

class _AmigosInicialState extends State<AmigosInicialScreen> {
  List<String> pessoas = []; // Lista de amigos a ser obtida do banco de dados
  final corPrincipal = Color.fromARGB(255, 52, 39, 194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicione amigos para começar :)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar por amigos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                filled: true,
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                        title: const Text(
                          'Nome da pessoa',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            adicionarAmigo(pessoas[index]);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(corPrincipal),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const GruposScreen(),
                      ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Avançar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void adicionarAmigo(String amigo) {
    setState(() {
      pessoas.add(amigo);
    });
  }
}
