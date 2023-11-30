import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class CriarGrupoDScreen extends StatefulWidget {
  const CriarGrupoDScreen({Key? key}) : super(key: key);

  @override
  _CriarGrupoDScreenState createState() => _CriarGrupoDScreenState();
}

class _CriarGrupoDScreenState extends State<CriarGrupoDScreen> {
  List<String> participantes =
      List.generate(10, (index) => 'Nome ${index + 1}');
  TextEditingController nomeGrupoController = TextEditingController();
  String? imagemDoGrupo; // Para armazenar o caminho da imagem do grupo

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
                                  image: NetworkImage(imagemDoGrupo!),
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
                                // Implementar a lógica para escolher uma imagem
                                // Pode abrir um seletor de imagem ou câmera
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
                'Participantes - ${participantes.length}',
                style: Styles.texto,
              ),
            ),
            const SizedBox(height: 20.0),

            // Lista de participantes
            Expanded(
              child: ListView.builder(
                itemCount: participantes.length,
                itemBuilder: (context, index) {
                  String nomeDoParticipante = participantes[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, right: 12.0, left: 12.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150'), // Substitua pela imagem real
                      ),
                      title: Text(
                        nomeDoParticipante,
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
          // Implementar a criação do grupo e voltar para a tela de grupos
        },
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
