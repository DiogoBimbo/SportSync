import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/models/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';

class InformacoesGrupoScreen extends StatefulWidget {
  final String nomeDoGrupo;
  final String imagemDoGrupo;
  final bool usuarioEhDono;

  InformacoesGrupoScreen({
    required this.nomeDoGrupo,
    required this.imagemDoGrupo,
    required this.usuarioEhDono,
  });

  @override
  _InformacoesGrupoScreenState createState() => _InformacoesGrupoScreenState();
}

class _InformacoesGrupoScreenState extends State<InformacoesGrupoScreen> {
  List<String> participantes =
      List.generate(10, (index) => 'Participante ${index + 1}');
  TextEditingController pesquisaController = TextEditingController();

  get usuarioEhDono => widget.usuarioEhDono;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
              ],
            ),
          ],
        ),
        actions: <Widget>[
          if (widget.usuarioEhDono)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Implementar a ação do botão
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${participantes.length} participantes',
              style: Styles.texto,
            ),
            if (usuarioEhDono)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Implementar a ação de adicionar participantes ir para a tela de adicionar participantes
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Implementar a ação de adicionar participantes ir para a tela de adicionar participantes
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
            Expanded(
              child: ListView.builder(
                itemCount: participantes.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Elemento para o usuário atual
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            'URL_DA_IMAGEM_DO_USUARIO', // Substitua pela imagem real
                          ),
                        ),
                        title: Text(
                          'Você',
                          style: Styles.textoDestacado,
                        ),
                      ),
                    );
                  }

                  // Elementos para os outros participantes
                  String nomeParticipante = participantes[index - 1];
                  bool usuarioEhDono = widget.usuarioEhDono;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Substitua pela imagem real
                        ),
                      ),
                      title: Text(
                        nomeParticipante,
                        style: Styles.textoDestacado,
                      ),
                      trailing: usuarioEhDono
                          ? IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                _desejaRemoverDoGrupo(participantes[index - 1]);
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                // Implementar a ação de sair do grupo
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            if (usuarioEhDono)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () {
                    // Implementar a ação de apagar o grupo
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void removerDoGrupo(String participante) {
    setState(() {
      participantes.remove(
          participante); // implementar a remoção do amigo do banco de dados
    });
  }

  void _desejaRemoverDoGrupo(String participante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remover do grupo',
            style: Styles.titulo,
          ),
          content: RichText(
            text: TextSpan(
              style: Styles.texto,
              children: <TextSpan>[
                const TextSpan(
                  text: 'Deseja remover ',
                ),
                TextSpan(
                  text: participante,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: ' ?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removerDoGrupo(participante);
              },
              child: Text(
                'Remover',
                style: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
