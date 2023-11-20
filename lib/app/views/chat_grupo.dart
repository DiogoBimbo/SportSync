import 'package:flutter/material.dart';
import 'package:pi_app/app/models/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/chat_screen.dart';
import 'package:pi_app/app/views/informacoes_grupo.dart';

class ChatGrupoScreen extends StatefulWidget {
  final String nomeDoGrupo;
  final String imagemDoGrupo;

  ChatGrupoScreen({required this.nomeDoGrupo, required this.imagemDoGrupo});

  @override
  _ChatGrupoScreenState createState() => _ChatGrupoScreenState();
}

class _ChatGrupoScreenState extends State<ChatGrupoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformacoesGrupoScreen(
                    usuarioEhDono:
                        true, // implementar a obtenção do status de dono do grupo do banco de dados
                    nomeDoGrupo:
                        'Nome do grupo', // implementar a obtenção do nome do grupo do banco de dados
                    imagemDoGrupo:
                        'https://via.placeholder.com/150' // implementar a obtenção da imagem do grupo do banco de dados
                    ),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacoesGrupoScreen(
                      usuarioEhDono:
                          true, // implementar a obtenção do status de dono do grupo do banco de dados
                      nomeDoGrupo:
                          'Nome do grupo', // implementar a obtenção do nome do grupo do banco de dados
                      imagemDoGrupo:
                          'https://via.placeholder.com/150' // implementar a obtenção da imagem do grupo do banco de dados
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: ChatScreen(),
    );
  }
}
