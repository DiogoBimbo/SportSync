import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/services/auth_service.dart';

class AmigosInicialScreen extends StatefulWidget {
  const AmigosInicialScreen({Key? key}) : super(key: key);

  @override
  _AmigosInicialState createState() => _AmigosInicialState();
}

class _AmigosInicialState extends State<AmigosInicialScreen> {
  List<String> pessoas = []; // Lista de amigos a ser obtida do banco de dados
  late FirebaseFirestore db;
  late AuthService auth;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicione amigos para começar :)',
          style: Styles.tituloBarra,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: BarraPesquisa(hintText: 'Pesquisar por pessoas...'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: pessoas.isEmpty ? 0.0 : 20.0,
                bottom: 20.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pessoas
                        .map(
                          (nome) => Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                removerDaLista(nome);
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      'https://via.placeholder.com/150',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  String nomeDaPessoa = 'Nome ${index + 1}';
                  bool pessoaJaAdicionada = pessoas.contains(nomeDaPessoa);

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 12.0, right: 12.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      title: Text(
                        limitarString(nomeDaPessoa, 25),
                        style: Styles.textoDestacado,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            if (pessoaJaAdicionada) {
                              removerDaLista(nomeDaPessoa);
                            } else {
                              adicionarNaLista(nomeDaPessoa);
                            }
                          });
                        },
                        icon: Icon(
                          pessoaJaAdicionada ? Icons.remove : Icons.add,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Styles.corPrincipal),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const GeralScreen(),
                      ));
                      // implementar a ação de adicionar os amigos no banco de dados
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Avançar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
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

  void adicionarNaLista(String amigo) {
    setState(() {
      pessoas.add(amigo); // implementar a adição do amigo no banco de dados
    });
  }

  void removerDaLista(String amigo) {
    setState(() {
      pessoas.remove(amigo); // implementar a remoção do amigo no banco de dados
    });
  }
}
