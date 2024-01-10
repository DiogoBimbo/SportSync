import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/group.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/services/group_service.dart';
import 'package:pi_app/services/missao_service.dart';

class RankingScreen extends StatefulWidget {
  final String groupId;

  const RankingScreen({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> ranking = [];
  String groupName = ''; // Variável para armazenar o nome do grupo
  String groupImageUrl = ''; // Variável para armazenar a URL da imagem do grupo
  final GroupService _groupService = GroupService();
  final MissoesService _missoesService = MissoesService();
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user_id';
  bool isLoading = true;

  Future<int> getPontosTotais(String userId, String groupId) async {
    // Busca todas as missões completadas do usuário para o grupo especificado
    var missoesCompletadas =
        await _missoesService.fetchMissoesCompletadasPorGrupo(userId, groupId);

    // Somar os pontos de todas as missões completadas
    int pontos = 0;
    for (var missaoCompletada in missoesCompletadas) {
      pontos += missaoCompletada.missao.pontos;
    }

    return pontos;
  }

  Future<void> calcularRanking() async {
    Group fetchedGroup = await _groupService.getGroupById(widget.groupId);
    var usuariosDoGrupo = await _groupService.getGroupMembers(fetchedGroup);

    List<Map<String, dynamic>> tempRanking = [];

    for (var usuario in usuariosDoGrupo) {
      int pontosTotais = await getPontosTotais(usuario.id, widget.groupId);

      tempRanking.add({
        'nome': usuario.id == currentUserId ? 'Você' : usuario.name,
        'pontos': pontosTotais,
        'userId': usuario.id,
        'photoUrl': usuario.photo,
      });
    }

    tempRanking.sort((a, b) => b['pontos'].compareTo(a['pontos']));

    setState(() {
      ranking = tempRanking;
      isLoading = false;
    });
  }

  void fetchGroupData() async {
    // Supondo que você tenha um método que retorna um objeto Group pelo seu ID
    Group group = await _groupService.getGroupById(widget.groupId);
    setState(() {
      groupName = group.name;
      groupImageUrl = group.imageUrl;
    });
  }


  String getPosicao(int index) {
  // O índice começa em 0, então adicionamos 1 para obter a posição correta.
  return "${index + 1}º";
}


  @override
  void initState() {
    super.initState();
    fetchGroupData();
    calcularRanking();
  }

  Color getMedalColor(int position) {
    switch (position) {
      case 1:
        return Styles.gold;
      case 2:
        return Styles.silver;
      case 3:
        return Styles.bronze;
      default:
        return Colors.white;
    }
  }

  Color _getPointsColor(String posicao) {
    switch (posicao) {
      case "1º":
        return Styles.gold;
      case "2º":
        return Styles.silver;
      case "3º":
        return Styles.bronze;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  groupImageUrl), // Substituir pela URL da imagem do grupo
            ),
            const SizedBox(width: 10),
            Text(limitarString(groupName, 13),
                style: Styles.tituloBarra), // Substituir pelo nome do grupo
          ],
        ),
      ),
      body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator()) // Mostra o indicador de progresso enquanto carrega
            : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('RANKING', style: Styles.titulo),
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ranking.length,
                itemBuilder: (context, index) {
                  final item = ranking[index];
                  bool showBorder = index <
                      3; // A borda será mostrada para as primeiras três posições
                  Color borderColor = getMedalColor(
                      index + 1); // A cor da borda baseada na posição
                  final isCurrentUser = item['userId'] == currentUserId;
                  return Container(
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.grey[800] : null,
                      borderRadius:
                          BorderRadius.circular(5), // Arredonda as bordas
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              getPosicao(index),
                              style: Styles.tituloBarra.copyWith(
                                  color: _getPointsColor(getPosicao(index))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: showBorder ? 22 : 22,
                              backgroundColor: showBorder
                                  ? borderColor
                                  : const Color.fromARGB(0, 200, 84, 84),
                              child: CircleAvatar(
                                radius: showBorder ? 20 : 22,
                                backgroundImage: NetworkImage(item['photoUrl']),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                isCurrentUser ? 'Você' : item["nome"],
                                style: Styles.textoDestacado.copyWith(
                                  color: _getPointsColor(getPosicao(index)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              '${item["pontos"]} pontos',
                              style: TextStyle(
                                color: _getPointsColor(getPosicao(index)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}