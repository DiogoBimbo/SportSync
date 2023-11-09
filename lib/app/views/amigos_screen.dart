import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/adicionar_amigos_screen.dart';

class AmigosScreen extends StatefulWidget {
  @override
  _AmigosScreenState createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen> {
  List<String> amigos = []; // Lista de amigos a ser obtida do banco de dados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: amigos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Você ainda não possui nenhum amigo :(',
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
                        adicionarAmigo();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.group_add, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'Adicione um amigo',
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
                          'MEUS AMIGOS',
                          style: Styles.titulo,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: BarraPesquisa(hintText: 'Pesquisar por amigos...'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: amigos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                // Implemente a ação quando o amigo for clicado
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      'https://via.placeholder.com/150'), // imagem do amigo a ser obtida do banco de dados
                                ),
                                title: Text(
                                  amigos[
                                      index], // Nome do amigo a ser obtido do banco de dados
                                  style: Styles.textoDestacado,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    removerAmigo(amigos[index]);
                                  },
                                  icon: const Icon(Icons.remove),
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
          adicionarAmigo();
        },
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
      ),
    );
  }

  // leva para a tela de adicionar amigos( adiciona o amigo na lista para teste )
  void adicionarAmigo() {
    setState(() {
      amigos.insert(0, 'Novo Amigo ${amigos.length + 1}');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AdicionarAmigosScreen(),
      ));
    });
  }

  void removerAmigo(String amigo) {
    setState(() {
      amigos.remove(amigo); // implementar a remoção do amigo do banco de dados
    });
  }
}
