import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/models/missao_completada_model.dart';
import 'package:pi_app/app/models/missao_model.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/services/missao_service.dart';

class MissoesWidget extends StatefulWidget {
  final String groupId;

  const MissoesWidget({Key? key, required this.groupId}) : super(key: key);

  @override
  _MissoesWidgetState createState() => _MissoesWidgetState();
}

class _MissoesWidgetState extends State<MissoesWidget> {
  final MissoesService _missoesService = MissoesService();
  List<Missao> _missoes = [];
  List<String> _idsMissoesCompletadas = [];
  Set<String> _tempCompletedMissions = {};
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> fetchMissions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Missoes').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar missões: $e');
    }
  }

  Future<void> completarMissao(String missaoId, String grupoId) async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('MissoesCompletadas')
          .add({
        'missaoId': missaoId,
        'grupoId': grupoId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao salvar missão completa: $e');
    }
  }

  Future<void> cancelarMissaoCompletada(String missaoId, String grupoId) async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      // Referência à subcoleção de missões completadas do usuário
      var missoesCompletadasRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('MissoesCompletadas');

      // Encontre o documento com o 'missaoId' e 'grupoId' correspondentes
      var querySnapshot = await missoesCompletadasRef
          .where('missaoId', isEqualTo: missaoId)
          .where('grupoId', isEqualTo: grupoId)
          .get();

      // Se o documento existir, exclua-o
      for (var doc in querySnapshot.docs) {
        await missoesCompletadasRef.doc(doc.id).delete();
      }

      // Remover o ID da missão das missões completadas temporariamente armazenadas
      _tempCompletedMissions.remove(missaoId);

      // Atualizar o estado da aplicação
      setState(() {});
    } catch (e) {
      print('Erro ao cancelar missão completada: $e');
      // Tratamento de erros, como mostrar um SnackBar
    }
  }

  Future<void> _fetchTodasMissoes() async {
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    // Buscar todas as missões
    List<Missao> allMissoes = await _missoesService.fetchMissoes();

    // Buscar as missões completadas pelo usuário que correspondem ao groupId
    List<MissaoCompletada> completedMissoes = await _missoesService.fetchMissoesCompletadasPorGrupo(currentUserId, widget.groupId);

    // Criar uma lista somente com as IDs das missões completadas
    List<String> completedIds = completedMissoes.map((missao) => missao.idMissao).toList();

    // Atualizar o estado
    setState(() {
      _missoes = allMissoes;
      _idsMissoesCompletadas = completedIds;
      isLoading = false;
    });
  } catch (e) {
    print("Erro ao buscar missões: $e");
    // Tratamento de erro
  }
}


  void _toggleMissionState(String missaoId, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        _tempCompletedMissions.add(missaoId);
      } else {
        _tempCompletedMissions.remove(missaoId);
      }
    });
  }


  void reloadPageData() {
    // Esta função é chamada para recarregar os dados da página.
    _fetchTodasMissoes();
  }


  @override
  void initState() {
    super.initState();
    _fetchTodasMissoes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildMissoesSection()],
    );
  }

  Widget _buildMissoesSection() {
    if (isLoading) {
      // Mostra o indicador de carregamento enquanto as missões estão sendo carregadas
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        const Text('MISSÕES', style: Styles.titulo),
        const SizedBox(height: 20),
        const BarraPesquisa(hintText: 'pesquisar'),
        _buildFilterChips(),
        const SizedBox(height: 20),
        ..._missoes.map(_buildMissaoCard).toList(),
      ],
    );
  }

  Widget _buildMissaoCard(Missao missao) {
    bool completa = _idsMissoesCompletadas.contains(missao.id) ||
        _tempCompletedMissions.contains(missao.id);
    double opacity = completa ? 0.5 : 1.0;

    return Card(
      color: completa
          ? const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5)
          : Colors.grey[800],
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 24),
          initiallyExpanded: missao.expanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              missao.expanded;
            });
          },
          title: Opacity(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDificuldadeEsporteRow(
                      missao.nivelMissao, missao.esporte),
                  const Spacer(),
                  Text(
                      completa
                          ? '${missao.pontos} pts'
                          : '+ ${missao.pontos} pts',
                      style: Styles.textoDestacado),
                ],
              ),
            ),
          ),
          subtitle: Opacity(
            opacity: opacity,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(missao.iconeEsporte),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        missao.nome,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration:
                              completa ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Icon(
                        missao.expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          trailing: const SizedBox.shrink(),
          children: [
            Opacity(
              opacity: opacity,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 12.0),
                child: Text(
                  missao.descricao,
                  textAlign: TextAlign.left,
                  style: Styles.texto.copyWith(height: 1.5),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    bool isCurrentlyCompleted =
                        _idsMissoesCompletadas.contains(missao.id) ||
                            _tempCompletedMissions.contains(missao.id);

                    if (isCurrentlyCompleted) {
                      // Cancela a missão completada
                      cancelarMissaoCompletada(missao.id, widget.groupId);
                      _toggleMissionState(missao.id,
                          false); 
                      reloadPageData();
                    } else {
                      // Lógica para completar a missão
                      completarMissao(missao.id, widget.groupId);
                      _toggleMissionState(
                          missao.id, true);
                      reloadPageData();
                    }

                    _mostrarNotificacao(
                        missao.nome, missao.pontos, !isCurrentlyCompleted);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: completa
                        ? const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5)
                        : Styles.corPrincipal,
                    side: completa
                        ? const BorderSide(
                            color: Color.fromARGB(255, 239, 83, 80), width: 2)
                        : BorderSide.none,
                  ),
                  child: Text(
                    completa ? 'Cancelar' : 'Completar',
                    style: TextStyle(
                      color: completa ? Colors.red[400] : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  Widget _buildDificuldadeEsporteRow(String dificuldade, String esporte) {
    return Row(
      children: [
        _buildDificuldadeTag(dificuldade),
        const SizedBox(width: 12),
        _buildEsporteTag(esporte),
      ],
    );
  }

  Widget _buildDificuldadeTag(String dificuldade) {
    return Container(
      decoration: BoxDecoration(
        color: _getColorFromDificuldade(dificuldade),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        dificuldade,
        style: Styles.tag,
      ),
    );
  }

  Widget _buildEsporteTag(String esporte) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        esporte,
        style: Styles.tag,
      ),
    );
  }

  Color _getColorFromDificuldade(String dificuldade) {
    switch (dificuldade.toLowerCase()) {
      case "fácil":
        return Styles.corFacil;
      case "média":
        return Styles.corMedio;
      case "difícil":
        return Styles.corDificil;
      default:
        return Colors.grey; // Cor padrão
    }
  }

  Widget _buildFilterChips() {
    return SizedBox();
    // return SizedBox(
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.horizontal,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         ChoiceChip(
    //           label: const Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 0),
    //             child: Text('Todas',
    //                 style: TextStyle(
    //                     fontSize: 13,
    //                     fontWeight: FontWeight.bold,
    //                     fontFamily: 'Inter')),
    //           ),
    //           selected: _mostrarTodas,
    //           onSelected: (bool selected) {
    //             setState(() {
    //               if (selected) {
    //                 _mostrarTodas = true;
    //                 _mostraCompletas = false; // Desativa os outros filtros
    //               }
    //             });
    //           },
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           selectedColor: Colors.grey[900],
    //           disabledColor: Colors.grey,
    //           avatar: const Padding(
    //             padding: EdgeInsets.only(left: 8.0),
    //             child: Icon(Icons.all_inclusive),
    //           ),
    //         ),
    //         SizedBox(width: 8),
    //         ChoiceChip(
    //           label: const Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 0),
    //             child: Text('Completas',
    //                 style: TextStyle(
    //                     fontSize: 13,
    //                     fontWeight: FontWeight.bold,
    //                     fontFamily: 'Inter')),
    //           ),
    //           selected: !_mostrarTodas && _mostraCompletas,
    //           onSelected: (bool selected) {
    //             setState(() {
    //               _mostrarTodas = false;
    //               _mostraCompletas = selected;
    //             });
    //           },
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           selectedColor: Styles.corPrincipal,
    //           disabledColor: Colors.grey,
    //           avatar: const Padding(
    //             padding: EdgeInsets.only(left: 8.0),
    //             child: Icon(Icons.check),
    //           ),
    //         ),
    //         SizedBox(width: 8),
    //         ChoiceChip(
    //           label: const Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 0),
    //             child: Text('Incompletas',
    //                 style: TextStyle(
    //                     fontSize: 13,
    //                     fontWeight: FontWeight.bold,
    //                     fontFamily: 'Inter')),
    //           ),
    //           selected: !_mostrarTodas && !_mostraCompletas,
    //           onSelected: (bool selected) {
    //             setState(() {
    //               _mostrarTodas = false;
    //               _mostraCompletas = !selected;
    //             });
    //           },
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           selectedColor: Colors.red[400],
    //           disabledColor: Colors.grey,
    //           avatar: const Padding(
    //             padding: EdgeInsets.only(left: 8.0),
    //             child: Icon(Icons.close),
    //           ),
    //         ),
    //         // Adicione outros filtros se necessário
    //       ],
    //     ),
    //   ),
    // );
  }

  void _mostrarNotificacao(String nomeMissao, int pontos, bool completa) {
    final snackbar = SnackBar(
      backgroundColor: completa ? Styles.corPrincipal : Colors.red[400],
      content: RichText(
        text: TextSpan(
          style: Styles.texto,
          children: <TextSpan>[
            TextSpan(
              text: completa ? 'Missão "' : 'Missão "',
            ),
            TextSpan(text: nomeMissao, style: Styles.textoDestacado),
            TextSpan(
              text: completa ? '" completa! ' : '" cancelada! ',
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: completa ? '+ $pontos pontos' : '- $pontos pontos',
                  style: Styles.textoDestacado,
                ),
                TextSpan(
                  text: completa
                      ? ' foram adicionados ao seu ranking.'
                      : ' foram subtraídos do seu ranking.',
                  style: Styles.texto,
                ),
              ],
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
