import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';

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
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Novo Grupo',
              style: Styles.tituloBarra, // alterar
            ),
            SizedBox(height: 1.0),
            Text(
              'Adicionar participantes',
              style: Styles.texto, // alterar
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BarraPesquisa(hintText: 'Pesquisar por amigos...'),
            Padding(
              padding: EdgeInsets.only(
                top: amigos.isEmpty ? 0.0 : 20.0,
                bottom: 20.0,
              ),
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
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  String nomeDoAmigo = 'Nome ${index + 1}';
                  bool amigoJaAdicionado = amigos.contains(nomeDoAmigo);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
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
                          nomeDoAmigo,
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
          // implementar a ação de adicionar participantes ao grupo e ir para a próxima tela
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
