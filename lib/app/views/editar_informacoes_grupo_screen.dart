import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/chat_grupo_screen.dart';
import 'package:pi_app/services/group_service.dart';

class EditarGrupoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImage;

  const EditarGrupoScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.groupImage,
  }) : super(key: key);

  @override
  _EditarGrupoScreenState createState() => _EditarGrupoScreenState();
}

class _EditarGrupoScreenState extends State<EditarGrupoScreen> {
  late TextEditingController nomeGrupoController;
  String? imgGrupo;
  File? imagemDoGrupo;

  Future<void> _escolherImagem() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagemDoGrupo = File(image.path); // Atualiza para um objeto File
      });
    }
  }


  Future<void> atualizarDadosDoGrupo() async {
  String nomeDoGrupo = nomeGrupoController.text.trim();

  if (nomeDoGrupo.isEmpty) {
    // Mostrar erro se o nome do grupo estiver vazio
    return;
  }

  String? imageUrl = widget.groupImage; // Começa com a imagem atual do grupo

  try {
    if (imagemDoGrupo != null) {
      // Se uma nova imagem foi selecionada, faça o upload
      imageUrl = await GroupService().uploadGroupImage(imagemDoGrupo!.path);
    }

    // Atualize o registro do grupo com o novo nome e a nova imagem (se houver)
    FirebaseFirestore.instance.collection('Groups').doc(widget.groupId).update({
      'name': nomeDoGrupo,
      'imageUrl': imageUrl,
    });

    Navigator.of(context).pop();
    // Mostrar confirmação e retornar para a tela anterior
  } catch (e) {
    print('Erro ao salvar alterações: $e');
    // Mostrar erro
  }
}


  @override
  void initState() {
    super.initState();
    nomeGrupoController = TextEditingController(text: widget.groupName);
    if (widget.groupImage.isNotEmpty) {
      imagemDoGrupo = File(widget.groupImage); // Inicializar com a imagem atual do grupo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Editar Grupo',
          style: Styles.tituloBarra,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[700],
                    image: DecorationImage(
                      image: imagemDoGrupo != null
                      ? FileImage(imagemDoGrupo!) as ImageProvider
                      : NetworkImage(widget.groupId) // Placeholder image
                ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Styles.corPrincipal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.white,
                      onPressed: () {
                        _escolherImagem();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
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
            const SizedBox(height: 20.0),
            // Botões na parte inferior da tela
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // implementar a ação de cancelar as alterações
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Styles.corPrincipal),
                            ),
                            onPressed: () {
                              atualizarDadosDoGrupo();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Salvar',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
