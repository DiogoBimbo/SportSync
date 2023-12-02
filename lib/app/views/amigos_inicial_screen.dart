import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/services/user_service.dart';

class AmigosInicialScreen extends StatefulWidget {
  const AmigosInicialScreen({Key? key}) : super(key: key);

  @override
  _AmigosInicialState createState() => _AmigosInicialState();
}

class _AmigosInicialState extends State<AmigosInicialScreen> {
  final UserService _userService = UserService();
  List<User> todosUsuarios =
      []; // Lista de todos os usuários obtidos do banco de dados
  List<User> usuariosSelecionados =
      []; // Lista de usuários selecionados para adicionar como amigos

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      List<User> usersList = await _userService.fetchUsers();

      setState(() {
        todosUsuarios =
            usersList.where((user) => user.id != currentUserId).toList();
      });
    } catch (e) {
      // Tratar o erro aqui
      print(e); // Para fins de depuração
    }
  }

  void adicionarNaLista(User usuario) {
    setState(() {
      usuariosSelecionados.add(usuario); // Adiciona o objeto User
    });
  }

  void removerDaLista(User usuario) {
    setState(() {
      usuariosSelecionados.remove(usuario); // Remove o objeto User
    });
  }

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
                top: usuariosSelecionados.isEmpty ? 0.0 : 20.0,
                bottom: 20.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: usuariosSelecionados.map((User usuario) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            removerDaLista(usuario);
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      usuario.photo, // foto do usuário
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
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 70,
                                child: Center(
                                  child: Text(
                                    limitarString(
                                        usuario.name, 8), // nome do usuário
                                    style: Styles.conteudo,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    todosUsuarios.length, //  tamanho da lista de usuários
                itemBuilder: (context, index) {
                  User usuario = todosUsuarios[index];
                  bool isSelecionado = usuariosSelecionados.contains(
                      usuario); // Verifica se o usuário está na lista de selecionados

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 12.0, right: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            NetworkImage(usuario.photo), // foto do usuário
                      ),
                      title: Text(
                        limitarString(usuario.name, 25), // nome do usuário
                        style: Styles.textoDestacado,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (isSelecionado) {
                            removerDaLista(usuario);
                          } else {
                            adicionarNaLista(usuario);
                          }
                        },
                        icon: Icon(
                          isSelecionado ? Icons.remove : Icons.add,
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
                    onPressed: () async {
                      String currentUserId =
                          auth.FirebaseAuth.instance.currentUser?.uid ?? '';
                      for (var usuario in usuariosSelecionados) {
                        await _userService.sendFriendRequest(
                            currentUserId, usuario.id);
                      }
                      // Opcional: Navegar para outra tela após enviar as solicitações
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const GeralScreen()),
                      );
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
}
