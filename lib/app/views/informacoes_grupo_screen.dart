import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/components/notificacao_de_verificacao.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/conta_amigo_screen.dart';
import 'package:pi_app/app/views/editar_informacoes_grupo_screen.dart';

class InformacoesGrupoScreen extends StatefulWidget {
  final String nomeDoGrupo;
  final String imagemDoGrupo;
  final bool usuarioEhDono;

  const InformacoesGrupoScreen({
    super.key,
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
  get nomeDoGrupo => widget.nomeDoGrupo;

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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditarGrupoScreen(),
                ));
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmigoContaScreen(
                              nomeAmigo: nomeParticipante,
                              imagemDoAmigo:
                                  'https://via.placeholder.com/150', // Substitua pela imagem real
                              eloDoAmigo: 'Diamante',
                              missoesCumpridas: 100,
                              missoesFaceis: 50,
                              missoesMedias: 30,
                              missoesDificeis: 20,
                            ),
                          ),
                        );
                      },
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
                                  _desejaRemoverDoGrupo(
                                      participantes[index - 1]);
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
                  if (usuarioEhDono)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, left: 20.0),
                      child: TextButton(
                        onPressed: () {
                          _desejaApagarGrupo(nomeDoGrupo);
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
        return ConfirmDialog(
            title: 'Remover do grupo',
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
                        height: 1.5),
                  ),
                  const TextSpan(
                    text: ' do grupo?',
                  ),
                ],
              ),
            ),
            confirmButtonText: 'Remover',
            cancelButtonText: 'Cancelar',
            onConfirm: () {
              Navigator.of(context).pop();
              removerDoGrupo(participante);
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
            // implementar a ação de sair do grupo
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
            // implementar a ação de apagar o grupo
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          customIcon: const Icon(Icons.delete),
        );
      },
    );
  }
}
