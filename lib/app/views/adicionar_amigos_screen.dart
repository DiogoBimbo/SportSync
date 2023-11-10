import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';

class AdicionarAmigosScreen extends StatefulWidget {
  const AdicionarAmigosScreen({Key? key}) : super(key: key);

  @override
  _AdicionarAmigosState createState() => _AdicionarAmigosState();
}

class _AdicionarAmigosState extends State<AdicionarAmigosScreen> {
  List<String> pessoas = []; // Lista de amigos a ser obtida do banco de dados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicione amigos',
          style: Styles.adcAmigos,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BarraPesquisa(hintText: 'Pesquisar por pessoas...'),
            Padding(
              padding: EdgeInsets.only(
                top: pessoas.isEmpty ? 0.0 : 20.0,
                bottom: 20.0,
              ),
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
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  String nomeDaPessoa = 'Nome ${index + 1}';
                  bool pessoaJaAdicionada = pessoas.contains(nomeDaPessoa);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      title: Text(
                        nomeDaPessoa,
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
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: pessoas.isEmpty
                        ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Styles.corPrincipal.withOpacity(0.5)),
                          )
                        : ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Styles.corPrincipal),
                          ),
                    onPressed: pessoas.isEmpty
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            // implementar a ação de adicionar os amigos no banco de dados
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Adicionar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: pessoas.isEmpty ? Colors.grey : Colors.white,
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
