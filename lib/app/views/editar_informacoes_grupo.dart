import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class EditarGrupoScreen extends StatefulWidget {
  const EditarGrupoScreen({Key? key}) : super(key: key);

  @override
  _EditarGrupoScreenState createState() => _EditarGrupoScreenState();
}

class _EditarGrupoScreenState extends State<EditarGrupoScreen> {
  TextEditingController nomeGrupoController = TextEditingController();
  String? imagemDoGrupo; // Para armazenar o caminho da imagem do grupo

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
                    image: imagemDoGrupo != null
                        ? DecorationImage(
                            image: NetworkImage(imagemDoGrupo!),
                            fit: BoxFit.cover,
                          )
                        : null,
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
                        // Implementar a ação de abrir a câmera
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
                              Navigator.pop(context);
                              // implementar a ação de salvar as alterações no banco de dados
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
