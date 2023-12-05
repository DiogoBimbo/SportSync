import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/services/user_service.dart';

class AdicionarPScreen extends StatefulWidget {
  final String groupId;
  final List<String> existingMemberIds;
  const AdicionarPScreen({
    Key? key,
    required this.groupId,
    required this.existingMemberIds,
  }) : super(key: key);

  @override
  _AdicionarPState createState() => _AdicionarPState();
}

class _AdicionarPState extends State<AdicionarPScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  List<User> todosAmigos = [];
  List<User> amigosSelecionados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Carrega todos os amigos primeiro
  }

  void _fetchUsers() async {
  setState(() {
    isLoading = true;
  });
    try {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    List<User> usersList = await _userService.fetchUsers();
    List<String> friendIds = await _userService.fetchUserFriends(currentUserId);

    // Temporariamente armazenar todos os amigos
    List<User> allFriends = usersList.where((user) => friendIds.contains(user.id)).toList();

    _fetchExistingGroupMembers(allFriends); // Passa todos os amigos para a função de filtragem
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> addMemberToRanking(String groupId, String memberId) async {
  DocumentReference rankingDocRef = _firestore
      .collection('Groups')
      .doc(groupId)
      .collection('Ranking')
      .doc(memberId);

  return rankingDocRef.set({
    'userId': memberId,
    'points': 0, // Pontuação inicial
    'lastUpdated': FieldValue.serverTimestamp(),
  });
}



  void _adicionarMembrosAoGrupoExistente() async {
    // Atualize a lista de membros do grupo no Firestore
    try {
      // Crie um mapa dos novos membros para adicionar
      Map<String, String> newMembersWithStatus = {};
      for (var user in amigosSelecionados) {
        // Inclua apenas os novos membros que ainda não estão no grupo
        if (!widget.existingMemberIds.contains(user.id)) {
          newMembersWithStatus[user.id] =
              'normal'; // Ou outro status apropriado
          await addMemberToRanking(widget.groupId, user.id);
        }
      }

      // Referência para o documento do grupo no Firestore
      DocumentReference groupDocRef =
          FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);

      // Atualização atomica para garantir a integridade dos dados
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupDocRef);

        if (groupSnapshot.exists) {
          // Atualiza o documento do grupo com os novos membros
          Map<String, String> updatedMembersWithStatus =
              Map<String, String>.from(
                  groupSnapshot['membersWithStatus'] as Map);
          updatedMembersWithStatus.addAll(newMembersWithStatus);

          transaction.update(
              groupDocRef, {'membersWithStatus': updatedMembersWithStatus});
          // Indicar sucesso ao usuário
          // Bota um snackbar ai pfvr 🥺🥺 (snackbarcustom)
        }
      });

      // Remova a tela atual da pilha de navegação para voltar à tela do grupo
      Navigator.pop(context, true); // 'true' indica que os membros foram adicionados

    } catch (e) {
      // Se algo der errado, mostre uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar membros: $e'),
        ),
      );
    }
  }


  void _fetchExistingGroupMembers(List<User> allFriends) async {
  DocumentReference groupDocRef = FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);
  DocumentSnapshot groupSnapshot = await groupDocRef.get();

  if (groupSnapshot.exists) {
    Map<String, dynamic> data = groupSnapshot.data() as Map<String, dynamic>;
    List<String> existingMemberIds = List<String>.from(data['membersWithStatus'].keys);

    setState(() {
      // Filtra os amigos que já são membros do grupo
      todosAmigos = allFriends.where((user) => !existingMemberIds.contains(user.id)).toList();
      isLoading = false;
    });
  } else {
    setState(() {
      isLoading = false;
    });
  }
}

  void adicionarNaLista(User participante) {
    setState(() {
      amigosSelecionados.add(participante); // Adiciona o objeto User
    });
  }

  void removerDaLista(User participante) {
    setState(() {
      amigosSelecionados.remove(participante); // Remove o objeto User
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
              'Novos participantes',
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
          : todosAmigos.isEmpty
              ? const Center(
                  child: Text(
                    'Você não possui mais nenhum amigo para adicionar no grupo.',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child:
                            BarraPesquisa(hintText: 'Pesquisar por amigos...'),
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
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
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
                                                    amigo
                                                        .photo, // foto do amigo
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
                                                        const EdgeInsets.all(
                                                            2.0),
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
                            bool isSelecionado =
                                amigosSelecionados.contains(amigo);
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
                                        backgroundImage:
                                            NetworkImage(amigo.photo),
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
                _adicionarMembrosAoGrupoExistente();
                Navigator.pop(context, true);
              },
        child: Icon(Icons.check,
            color: amigosSelecionados.isEmpty
                ? Colors.white.withOpacity(0.5)
                : Colors.white),
      ),
    );
  }
}
