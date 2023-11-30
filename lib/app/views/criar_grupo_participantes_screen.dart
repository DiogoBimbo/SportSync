import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/views/criar_grupo_detalhes_screen.dart';

class CriarGrupoPScreen extends StatefulWidget {
  const CriarGrupoPScreen({Key? key}) : super(key: key);

  @override
  _CriarGrupoPState createState() => _CriarGrupoPState();
}

class _CriarGrupoPState extends State<CriarGrupoPScreen> {
  List<String> amigos = []; // Lista de amigos a ser obtida do banco de dados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Novo Grupo',
              style: Styles.tituloBarra,
            ),
            const SizedBox(height: 1.0),
            Text(
              amigos.isEmpty
                  ? 'Adicionar participantes'
                  : '${amigos.length} participante${amigos.length != 1 ? 's' : ''} selecionado${amigos.length != 1 ? 's' : ''}',
              style: Styles.conteudo,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const BarraPesquisa(hintText: 'Pesquisar por amigos...'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: amigos.isEmpty ? 0.0 : 20.0,
                bottom: 20.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: amigos
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
                  String nomeDoAmigo = 'Nome ${index + 1}';
                  bool amigoJaAdicionado = amigos.contains(nomeDoAmigo);

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 12.0, right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (amigoJaAdicionado) {
                            removerDaLista(nomeDoAmigo);
                          } else {
                            adicionarNaLista(nomeDoAmigo);
                          }
                        });
                      },
                      child: ListTile(
                        leading: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            if (amigoJaAdicionado)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Styles.corPrincipal,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2.0),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          limitarString(nomeDoAmigo, 25),
                          style: Styles.textoDestacado,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.corPrincipal,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CriarGrupoDScreen(),
          ));
          // implementar a ação de adicionar participantes ao grupo
        },
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  void adicionarNaLista(String amigo) {
    setState(() {
      amigos.add(amigo); // implementar a adição do amigo no banco de dados
    });
  }

  void removerDaLista(String amigo) {
    setState(() {
      amigos.remove(amigo); // implementar a remoção do amigo no banco de dados
    });
  }
}
