import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/components/notificacao_de_verificacao.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/adicionar_amigos_screen.dart';
import 'package:pi_app/app/views/solicitacao_amizade_screen.dart';
import 'package:pi_app/services/user_service.dart';

class AmigosScreen extends StatefulWidget {
  const AmigosScreen({super.key});

  @override
  _AmigosScreenState createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen> {
  final UserService _userService = UserService();
  List<User> amigos = []; // Lista de amigos a ser obtida do banco de dados
  List<User> solicitacoes = []; 
  bool isLoading = true; // Estado de carregamento adicionado

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void reloadPageData() {
  // Esta função é chamada para recarregar os dados da página.
  _fetchUsers();
}

  void _fetchUsers() async {
  try {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    List<User> usersList = await _userService.fetchUsers();
    List<String> friendIds = await _userService.fetchUserFriends(currentUserId);

    List<User> friendRequests = await _userService.fetchFriendRequests(currentUserId);

    setState(() {
      // Filtra a lista de todos os usuários para incluir apenas os amigos
      amigos = usersList.where((user) => 
        friendIds.contains(user.id)).toList();
      isLoading = false; // A busca foi completada
      solicitacoes = friendRequests;
    });
  } catch (e) {
    // Tratar o erro aqui
    print(e); // Para fins de depuração
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostra o indicador de progresso enquanto carrega
            : amigos.isEmpty
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
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.mail, color: Colors.white),
                        label: Text(
                          'Solicitações (${solicitacoes.length})',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SolicitacoesDeAmizadeScreen(),
                            ),
                          ).then((_) {
    // Este bloco é chamado quando a página para a qual navegamos é removida da pilha
    reloadPageData();
  });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Styles.corPrincipal, // Cor do botão
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'MEUS AMIGOS',
                                  style: Styles.tituloForte,
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.mail, color: Colors.white),
                                label: Text(
                                  'Solicitações (${solicitacoes.length})',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SolicitacoesDeAmizadeScreen(),
                                    ),
                                  ).then((_) {
    // Este bloco é chamado quando a página para a qual navegamos é removida da pilha
    reloadPageData();
  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Styles.corPrincipal, // Cor do botão
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child:
                              BarraPesquisa(hintText: 'Pesquisar por amigos...'),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: amigos.length,
                          itemBuilder: (context, index) {
                            User usuario = amigos[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => AmigoContaScreen(
                                  //       nomeAmigo: amigos[index],
                                  //       imagemDoAmigo:
                                  //           'https://via.placeholder.com/150',
                                  //       eloDoAmigo: 'Bronze',
                                  //       missoesCumpridas: 10,
                                  //       missoesFaceis: 5,
                                  //       missoesMedias: 3,
                                  //       missoesDificeis: 2,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage(usuario.photo)
                                  ),
                                  title: Text(
                                    limitarString(usuario.name, 20),
                                    style: Styles.textoDestacado,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _desejaRemoverAmigo(amigos[index]);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AdicionarAmigosScreen(),
      )).then((_) {
    // Este bloco é chamado quando a página para a qual navegamos é removida da pilha
    reloadPageData();
  });
    });
  }

  void removerAmigo(String amigo) {
    setState(() {
      amigos.remove(amigo); // implementar a remoção do amigo do banco de dados
    });
  }

  void _desejaRemoverAmigo(User amigo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'Desfazer amizade',
          content: RichText(
            text: TextSpan(
              style: Styles.texto,
              children: <TextSpan>[
                const TextSpan(
                  text: 'Deseja desfazer a amizade com ',
                ),
                TextSpan(
                  text: amigo.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.5),
                ),
                const TextSpan(
                  text: ' ?',
                ),
              ],
            ),
          ),
          confirmButtonText: 'Desfazer',
          cancelButtonText: 'Cancelar',
          onConfirm: () async {
            Navigator.of(context).pop(); // Fecha o dialog
            await _userService.removeFriend(auth.FirebaseAuth.instance.currentUser?.uid ?? '', amigo.id);
            reloadPageData(); // Atualiza a lista de amigos
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          customIcon: const Icon(Icons.person_remove),
        );
      },
    );
  }
}