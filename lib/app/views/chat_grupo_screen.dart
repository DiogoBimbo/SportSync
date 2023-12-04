import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/chat_screen.dart';
import 'package:pi_app/app/views/informacoes_grupo_screen.dart';
import 'package:pi_app/app/views/missoes_grupo_screen.dart';

class ChatGrupoScreen extends StatefulWidget {
  final String nomeDoGrupo;
  final String imagemDoGrupo;
  final String groupId;

  const ChatGrupoScreen(
      {super.key,
      required this.nomeDoGrupo,
      required this.imagemDoGrupo,
      required this.groupId});

  @override
  _ChatGrupoScreenState createState() => _ChatGrupoScreenState();
}

class _ChatGrupoScreenState extends State<ChatGrupoScreen> {
  String nomeDoGrupo = '';
  String imagemDoGrupo = '';

  @override
  void initState() {
    super.initState();
    fetchGroupInfo();
  }

  void fetchGroupInfo() async {
    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('Groups').doc(widget.groupId);

    groupRef.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          nomeDoGrupo = snapshot['name'] ?? '';
          imagemDoGrupo = snapshot['imageUrl'] ?? '';
        });
      }
    }).catchError((error) {
      print('Erro ao buscar informações do grupo: $error');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: kToolbarHeight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacoesGrupoScreen(groupId: widget.groupId,),
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.imagemDoGrupo),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(limitarString(widget.nomeDoGrupo, 18),
                        style: Styles.tituloBarra),
                    const SizedBox(height: 1.0),
                    const Text('Toque para dados do grupo',
                        style: Styles.conteudo),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacoesGrupoScreen(groupId: widget.groupId,),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const ChatScreen(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.corPrincipal, // corPrincipal
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MissoesGrupoScreen(groupId: widget.groupId,),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Missões do grupo',
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
            ),
          ),
        ],
      ),
    );
  }
}
