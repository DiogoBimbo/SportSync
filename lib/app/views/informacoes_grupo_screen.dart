import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/components/notificacao_de_verificacao.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/group.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/adicionar_participante_grupo.dart';
import 'package:pi_app/app/views/editar_informacoes_grupo_screen.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/services/group_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class InformacoesGrupoScreen extends StatefulWidget {
  final String groupId;

  const InformacoesGrupoScreen({
    super.key,
    required this.groupId,
  });

  @override
  _InformacoesGrupoScreenState createState() => _InformacoesGrupoScreenState();
}

class _InformacoesGrupoScreenState extends State<InformacoesGrupoScreen> {
  TextEditingController pesquisaController = TextEditingController();
  late Group group; // Informação do grupo
  bool isLoading = true;
  late List<User> members = [];
  bool isCurrentUserAdmin = false;

  void reloadPageData() {
    setState(() {
      isLoading = true;
      members.clear(); // Limpar a lista de membros
    });

    fetchGroupInfo().then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print('Erro ao recarregar dados: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchGroupInfo() async {
    GroupService groupService = GroupService();
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      // Busque as informações do grupo pelo ID
      Group fetchedGroup = await groupService.getGroupById(widget.groupId);
      // Use o novo método do serviço que espera um objeto Group
      List<User> fetchedMembers =
          await groupService.getGroupMembers(fetchedGroup);

      // Aqui você já tem a lista de membros, e pode verificar se o usuário atual é admin
      isCurrentUserAdmin = fetchedGroup.isUserAdmin(currentUserId);

      // Encontre o usuário atual e o coloque no início da lista, se necessário
      int currentUserIndex =
          fetchedMembers.indexWhere((member) => member.id == currentUserId);
      if (currentUserIndex != -1) {
        User currentUser = fetchedMembers.removeAt(currentUserIndex);
        fetchedMembers.insert(0, currentUser);
      }

      setState(() {
        group = fetchedGroup;
        members = fetchedMembers;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroupInfo();
  }

  void adicionarParticipante() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => AdicionarPScreen(
        groupId: widget.groupId,
        existingMemberIds: members.map((member) => member.id).toList(),
      ),
    ))
        .then((result) {
      if (result == true) {
        reloadPageData();
      }
    });
  }

  Future<void> removerMembroDoGrupo(String userId) async {
    // Referência para o documento do grupo no Firestore
    DocumentReference groupDocRef =
        FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);

    try {
      // Atualização atomica para garantir a integridade dos dados
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupDocRef);

        if (groupSnapshot.exists) {
          Map<String, dynamic> groupData =
              groupSnapshot.data() as Map<String, dynamic>;

          if (groupData['membersWithStatus'] != null &&
              groupData['membersWithStatus'][userId] != null) {
            // Remove o usuário do mapa de membros
            Map<String, String> updatedMembersWithStatus =
                Map<String, String>.from(groupData['membersWithStatus']);
            updatedMembersWithStatus.remove(userId);

            // Atualiza o documento do grupo com o novo mapa de membros
            transaction.update(
                groupDocRef, {'membersWithStatus': updatedMembersWithStatus});

            // Indicar sucesso ao usuário
            // Bota um snackbar ai pfvr 🥺🥺 (snackbarcustom)
          }
        }
      }).then((_) {
        // Recarrega os dados da tela ao retornar
        reloadPageData();
      });
    } catch (e) {
      // Se algo der errado, mostre uma mensagem de erro
      print('deu merda: $e');
    }
  }

  Future<void> sairDoGrupo() async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference groupDocRef =
        FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);

    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupDocRef);

        if (groupSnapshot.exists) {
          Map<String, dynamic> groupData =
              groupSnapshot.data() as Map<String, dynamic>;
          Map<String, String> membersWithStatus =
              Map<String, String>.from(groupData['membersWithStatus']);

          // Verifica se o usuário atual é o administrador
          if (groupData['admin'] == currentUserId) {
            membersWithStatus.remove(currentUserId);

            // Escolha um novo administrador se houver membros restantes
            if (membersWithStatus.isNotEmpty) {
              String newAdminId = membersWithStatus.keys.first;
              transaction.update(groupDocRef, {
                'admin': newAdminId,
                'membersWithStatus': membersWithStatus
              });
            } else {
              // Se não houver mais membros, apague o grupo
              transaction.delete(groupDocRef);
            }
          } else {
            // Simplesmente remove o usuário se ele não for o administrador
            membersWithStatus.remove(currentUserId);
            transaction
                .update(groupDocRef, {'membersWithStatus': membersWithStatus});
          }

          // Indicar sucesso ao usuário
          // Bota um snackbar ai pfvr 🥺🥺 (snackbarcustom)
        }
      }).then((_) {
        // Navegar de volta para a GruposScreen
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const GeralScreen()));
      });
    } catch (e) {
      print('Erro ao sair do grupo: $e');
      // Mostrar mensagem de erro
    }
  }

  Future<void> excluirGrupo() async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference groupDocRef =
        FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);

    try {
      DocumentSnapshot groupSnapshot = await groupDocRef.get();

      if (groupSnapshot.exists) {
        Map<String, dynamic> groupData =
            groupSnapshot.data() as Map<String, dynamic>;

        // Verifica se o usuário atual é o administrador

        // Exclui o grupo do Firestore
        await groupDocRef.delete();

        // Redireciona para a tela de grupos ou tela inicial
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const GeralScreen()));

        // Indicar sucesso ao usuário
        // Bota um snackbar ai pfvr 🥺🥺 (snackbarcustom)
      }
    } catch (e) {
      print('Erro ao excluir grupo: $e');
      // Mostrar mensagem de erro
    }
  }

  void _desejaRemoverDoGrupo(String participante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
            title: 'Remover do grupo',
            content: RichText(
              text: const TextSpan(
                style: Styles.texto,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Deseja remover o participante do grupo?',
                  ),
                ],
              ),
            ),
            confirmButtonText: 'Remover',
            cancelButtonText: 'Cancelar',
            onConfirm: () {
              Navigator.of(context).pop();
              removerMembroDoGrupo(participante);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
            customIcon: const Icon(Icons.person_remove));
      },
    );
  }

  void _desejaSairDoGrupo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'Sair do grupo',
          content: RichText(
              text: const TextSpan(
                  text: 'Você deseja sair do grupo?', style: Styles.texto)),
          confirmButtonText: 'Sair',
          cancelButtonText: 'Cancelar',
          onConfirm: () {
            sairDoGrupo();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          customIcon: const Icon(Icons.exit_to_app),
        );
      },
    );
  }

  void _desejaApagarGrupo(String nomeDoGrupo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'Apagar grupo',
          content: RichText(
            text: TextSpan(
              style: Styles.texto,
              children: <TextSpan>[
                const TextSpan(
                  text: 'Deseja apagar o grupo: ',
                ),
                TextSpan(
                  text: nomeDoGrupo,
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
          confirmButtonText: 'Apagar',
          cancelButtonText: 'Cancelar',
          onConfirm: () {
            Navigator.of(context).pop();
            excluirGrupo();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          customIcon: const Icon(Icons.delete),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(group.imageUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(limitarString(group.name, 13),
                      style: Styles.tituloBarra),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            if (isCurrentUserAdmin)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EditarGrupoScreen(groupId: widget.groupId, groupImage: group.imageUrl, groupName: group.name),
                  )).then((_) {
        // Recarrega os dados da tela ao retornar
        reloadPageData();
      });
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${members.length} participantes',
                  style: Styles.texto,
                ),
                if (isCurrentUserAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              adicionarParticipante();
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      adicionarParticipante();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(0),
                                      backgroundColor: Styles.corPrincipal,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                const Text(
                                  'Adicionar participantes',
                                  style: Styles.textoDestacado,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20.0),
                const BarraPesquisa(
                  hintText: 'Pesquisar por participantes...',
                ),
                const SizedBox(height: 20.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    User member = members[index];
                    String currentUserId =
                        auth.FirebaseAuth.instance.currentUser?.uid ?? '';
                    bool isCurrentUser = member.id == currentUserId;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AmigoContaScreen(
                          //       nomeAmigo: nomeParticipante,
                          //       imagemDoAmigo:
                          //           'https://via.placeholder.com/150', // Substitua pela imagem real
                          //       eloDoAmigo: 'Diamante',
                          //       missoesCumpridas: 100,
                          //       missoesFaceis: 50,
                          //       missoesMedias: 30,
                          //       missoesDificeis: 20,
                          //     ),
                          //   ),
                          // );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                  member.photo) // Substitua pela imagem real
                              ),
                          title: Text(
                            isCurrentUser ? 'Você' : member.name,
                            style: Styles.textoDestacado,
                          ),
                          trailing: (isCurrentUserAdmin && !isCurrentUser)
                              ? IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    _desejaRemoverDoGrupo(member.id);
                                  },
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _desejaSairDoGrupo();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red[400],
                          ),
                          const SizedBox(width: 10),
                          Text('Sair do Grupo',
                              style: TextStyle(
                                color: Colors.red[400],
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                    if (isCurrentUserAdmin)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 20.0),
                        child: TextButton(
                          onPressed: () {
                            _desejaApagarGrupo(group.name);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red[400]),
                              const SizedBox(width: 10),
                              Text('Apagar Grupo',
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}