import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/group.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/chat_grupo_screen.dart';
import 'package:pi_app/app/views/criar_grupo_participantes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class GruposScreen extends StatefulWidget {
  const GruposScreen({super.key});

  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  List<Group> grupos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  
  void _fetchGroups() async {
    try {
      String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      QuerySnapshot groupSnapshot = await _firestore.collection('Groups')
        .where('membersWithStatus.$currentUserId', isNull: false)
        .get();

      List<Group> fetchedGroups = groupSnapshot.docs
        .map((doc) => Group.fromDocument(doc))
        .toList();

      setState(() {
        grupos = fetchedGroups;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar grupos: $e');
    }
  }


  void _adicionarGrupo() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CriarGrupoPScreen(),
      ));
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
         grupos.isEmpty
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0, top: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'MEUS GRUPOS',
                            style: Styles.tituloForte,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child:
                            BarraPesquisa(hintText: 'Pesquisar por grupos...'),
                      ),
                      ListView.builder(
                        itemCount: grupos.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Group grupo = grupos[index];
                          DateTime dataCriacao = grupo.createdAt.toDate(); // Converter Timestamp para DateTime
                          String dataFormatada = DateFormat('dd/MM/yyyy').format(dataCriacao);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                String selectedGroupId = grupos[index].id;
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatGrupoScreen(
                                    nomeDoGrupo: grupo.name,
                                    imagemDoGrupo: grupo.imageUrl,
                                    groupId: selectedGroupId, // Passando o groupId
                                  ),
                                ));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(grupo.imageUrl), // imagem do grupo a ser obtida do banco de dados
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      limitarString(grupo.name, 28),// Nome do grupo a ser obtido do banco de dados
                                      style: Styles.textoDestacado,
                                    ),
                                    Text(
                                      "Criado em: $dataFormatada", // Data de criação a ser obtida do banco de dados
                                      style: Styles.conteudo,
                                    ),
                                  ],
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
}
