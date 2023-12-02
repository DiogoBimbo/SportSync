import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/views/criar_grupo_detalhes_screen.dart';
import 'package:pi_app/services/user_service.dart';

class CriarGrupoPScreen extends StatefulWidget {
  const CriarGrupoPScreen({Key? key}) : super(key: key);

  @override
  _CriarGrupoPState createState() => _CriarGrupoPState();
}

class _CriarGrupoPState extends State<CriarGrupoPScreen> {
  final UserService _userService = UserService();
  List<User> todosAmigos = [];
  List<User> amigosSelecionados = [];
  bool isLoading = true; // Estado de carregamento adicionado

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      List<User> usersList = await _userService.fetchUsers();
      List<String> friendIds =
          await _userService.fetchUserFriends(currentUserId);
      setState(() {
        todosAmigos =
            usersList.where((user) => friendIds.contains(user.id)).toList();
        isLoading =
            false; // Aqui você define isLoading como false quando o carregamento é concluído
      });
    } catch (e) {
      setState(() {
        isLoading =
            false; // Defina como false também no catch, caso haja uma exceção
      });
      print(e); // Para fins de depuração
    }
  }

  void adicionarNaLista(User amigo) {
    setState(() {
      amigosSelecionados.add(amigo); // Adiciona o objeto User
    });
  }

  void removerDaLista(User amigo) {
    setState(() {
      amigosSelecionados.remove(amigo); // Remove o objeto User
    });
  }

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
              amigosSelecionados.isEmpty
                  ? 'Adicionar participantes'
                  : '${amigosSelecionados.length} participante${amigosSelecionados.length != 1 ? 's' : ''} selecionado${amigosSelecionados.length != 1 ? 's' : ''}',
              style: Styles.conteudo,
            ),
          ],
        ),
      ),
      body: isLoading // Verifica se a busca está completa
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: BarraPesquisa(hintText: 'Pesquisar por amigos...'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: amigosSelecionados.isEmpty ? 0.0 : 20.0,
                      bottom: 20.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: amigosSelecionados
                              .map(
                                (User amigo) => Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      removerDaLista(amigo);
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                amigo.photo, // foto do amigo
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
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 70,
                                          child: Center(
                                            child: Text(
                                              limitarString(amigo.name,
                                                  8), // nome do amigo
                                              style: Styles.conteudo,
                                              textAlign: TextAlign.center,
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
                      itemCount: todosAmigos.length,
                      itemBuilder: (context, index) {
                        User amigo = todosAmigos[index];
                        bool isSelecionado = amigosSelecionados.contains(amigo);
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 12.0, left: 12.0, right: 12.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelecionado) {
                                  removerDaLista(amigo);
                                } else {
                                  adicionarNaLista(amigo);
                                }
                              });
                            },
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(amigo.photo),
                                  ),
                                  if (isSelecionado)
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
                                limitarString(amigo.name, 25),
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
        backgroundColor: amigosSelecionados.isEmpty
            ? Styles.corPrincipal.withOpacity(0.5)
            : Styles.corPrincipal, // Cor original
        onPressed: amigosSelecionados.isEmpty
            ? null // Desativa o botão se não houver amigos selecionados
            : () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CriarGrupoDScreen(participantes: amigosSelecionados),
                ));
              },
        child: Icon(Icons.arrow_forward,
            color: amigosSelecionados.isEmpty
                ? Colors.white.withOpacity(0.5)
                : Colors.white),
      ),
    );
  }
}
