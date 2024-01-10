import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/geral_screen.dart';
import 'package:pi_app/services/group_service.dart';

class CriarGrupoDScreen extends StatefulWidget {
  final List<User> participantes;
  const CriarGrupoDScreen({Key? key, required this.participantes})
      : super(key: key);

  @override
  _CriarGrupoDScreenState createState() => _CriarGrupoDScreenState();
}

class _CriarGrupoDScreenState extends State<CriarGrupoDScreen> {
  TextEditingController nomeGrupoController = TextEditingController();
  XFile? imagemDoGrupo; // Para armazenar o caminho da imagem do grupo

  void criarGrupo() async {
    String nomeGrupo = nomeGrupoController.text.trim();
    if (nomeGrupo.isEmpty) {
      mostrarAlerta('Erro', 'Por favor, insira um nome para o grupo.');
      return;
    }

    try {
      // Crie o registro do grupo no Firestore
      DocumentReference groupDocRef = await GroupService().createGroup(
        name: nomeGrupo,
        members: widget.participantes,
      );

      // Se o usuário selecionou uma imagem, faça o upload
      String? imageUrl;
      if (imagemDoGrupo != null) {
        imageUrl = await GroupService().uploadGroupImage(imagemDoGrupo!.path);
        // Atualize o registro do grupo com a URL da imagem
        await groupDocRef.update({'imageUrl': imageUrl});
      }

      // Sucesso: Navegue para a tela de grupos
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              GeralScreen(), // Substitua pela sua tela de grupos
        ),
      );
    } catch (e) {
      mostrarAlerta('Erro', 'Ocorreu um erro ao criar o grupo: $e');
    }
  }

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  selecionarImagem() async {
    final ImagePicker picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          imagemDoGrupo = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo Grupo',
          style: Styles.tituloBarra,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[700],
                          image: imagemDoGrupo != null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(imagemDoGrupo!.path),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                selecionarImagem();
                              },
                              child: Center(
                                child: imagemDoGrupo == null
                                    ? Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.grey[300],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      // Campo para inserir o nome do grupo
                      Expanded(
                        child: TextField(
                          controller: nomeGrupoController,
                          style: Styles.textoDestacado,
                          decoration: const InputDecoration(
                            hintText: 'Nome do grupo',
                            labelStyle: Styles.textoDestacado,
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Participantes - ${widget.participantes.length}',
                style: Styles.texto,
              ),
            ),
            const SizedBox(height: 20.0),

            // Lista de participantes
            Expanded(
              child: ListView.builder(
                itemCount: widget.participantes.length,
                itemBuilder: (context, index) {
                  User participante = widget.participantes[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, right: 12.0, left: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                            participante.photo), // Substitua pela imagem real
                      ),
                      title: Text(
                        participante.name,
                        style: Styles.textoDestacado,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.corPrincipal,
        onPressed: () {
          criarGrupo();
        },
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
