import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/models/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/chat_grupo.dart';
import 'package:pi_app/app/views/criar_grupo_participantes.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  List<String> grupos = []; // Lista de grupos a ser obtida do banco de dados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: grupos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Você ainda não possui nenhum grupo :(',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Styles.corPrincipal),
                      ),
                      onPressed: () {
                        _adicionarGrupo();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'Crie um grupo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0, top: 30.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'MEUS GRUPOS',
                          style: Styles.titulo,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: BarraPesquisa(hintText: 'Pesquisar por grupos...'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: grupos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatGrupoScreen(
                                      nomeDoGrupo:
                                          'Nome do grupo', // implementar a obtenção do nome do grupo do banco de dados
                                      imagemDoGrupo:
                                          'https://via.placeholder.com/150' // implementar a obtenção da imagem do grupo do banco de dados
                                      ),
                                ));
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      'https://via.placeholder.com/150'), // imagem do grupo a ser obtida do banco de dados
                                ),
                                title: Text(
                                  limitarString(grupos[index], 28), // Nome do grupo a ser obtido do banco de dados
                                  style: Styles.textoDestacado,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.corPrincipal,
        onPressed: () {
          _adicionarGrupo();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // apenas para teste
  void _adicionarGrupo() {
    setState(() {
      grupos.insert(0, 'Novo Grupo ${grupos.length + 1}');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CriarGrupoPScreen(),
      ));
    });
  }
}
