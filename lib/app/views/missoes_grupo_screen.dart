import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/components/missoes.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/group.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/ranking_screen.dart';
import 'package:pi_app/services/group_service.dart';
import 'package:pi_app/services/missao_service.dart';

class MissoesGrupoScreen extends StatefulWidget {
  final String groupId;
  const MissoesGrupoScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _MissoesGrupoScreenState createState() => _MissoesGrupoScreenState();
}

class _MissoesGrupoScreenState extends State<MissoesGrupoScreen> {
  final GroupService _groupService = GroupService();
  final MissoesService _missoesService = MissoesService();
  List<Map<String, dynamic>> topRanking = []; // Top 3 ranking
  List<Map<String, dynamic>> ranking = [];
  Map<String, dynamic>? currentUserRanking; // Ranking do usuário atual
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user_id';
  String groupName = ''; // Variável para armazenar o nome do grupo
  String groupImageUrl = ''; // Variável para armazenar a URL da imagem do grupo
  bool isLoading = true;


  void fetchGroupData() async {
    // Supondo que você tenha um método que retorna um objeto Group pelo seu ID
    Group group = await _groupService.getGroupById(widget.groupId);
    setState(() {
      groupName = group.name;
      groupImageUrl = group.imageUrl;
    });
  }


  Future<List<Map<String, dynamic>>> fetchMissionsByGroup(
      String groupId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Missions')
          .where('groupId', isEqualTo: groupId)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar missões: $e');
    }
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
      topRanking =
          ranking.take(3).toList(); // Atualiza topRanking com os 3 primeiros
      currentUserRanking = ranking.firstWhere(
        (user) => user['userId'] == currentUserId,
      );
      isLoading = false;
    });
  }

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

  @override
  void initState() {
    super.initState();
    calcularRanking();
    fetchGroupData();
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildRankingSection(),
                    const SizedBox(height: 10),
                    Divider(height: 1, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    MissoesWidget(groupId: widget.groupId),
                  ],
                ),
              ),
            ),
    );
  }

  Color getMedalColor(int position) {
    switch (position) {
      case 1:
        return Styles.gold; // Cor para o primeiro colocado
      case 2:
        return Styles.silver; // Cor para o segundo colocado
      case 3:
        return Styles.bronze; // Cor para o terceiro colocado
      default:
        return Colors.grey; // Cor padrão para outros
    }
  }

  Widget _buildUserRanking(Map<String, dynamic> userData, int position,
      {bool isTopRanker = false}) {
    double avatarRadius = isTopRanker ? 48 : 38; // ajuste conforme o design
    // A cor da borda varia de acordo com a posição
    Color borderColor = getMedalColor(position);

    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: borderColor,
                child: CircleAvatar(
                  radius: avatarRadius - 3,
                  backgroundImage: NetworkImage(userData['photoUrl']),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      '$positionº',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Text(limitarString(userData['nome'], 10), style: Styles.textoDestacado),
        Text('${userData['pontos']} pontos', style: Styles.texto),
      ],
    );
  }

  Widget _buildRankingSection() {
    if (currentUserRanking == null) return SizedBox.shrink();

    int currentUserPosition = ranking.indexOf(currentUserRanking!) + 1;

    if (ranking.length < 3) {
      return SizedBox.shrink(); // ou um widget de erro/placeholders
    }

    // Ordena a lista de ranking com base nos pontos
    ranking.sort((a, b) => b['pontos'].compareTo(a['pontos']));

    return Column(
      children: [
        const Text('RANKING', style: Styles.titulo),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUserRanking(ranking[1], 2),
            // Primeiro lugar
            _buildUserRanking(ranking[0], 1, isTopRanker: true),
            // Terceiro lugar
            _buildUserRanking(ranking[2], 3),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Você está em $currentUserPositionº lugar com ${currentUserRanking!['pontos']} pontos',
          style: Styles.textoDestacado,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RankingScreen(groupId: widget.groupId),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volcano, color: Styles.corLink),
              SizedBox(width: 8.0), // Espaço entre o ícone e o texto
              Text(
                'Consultar ranking',
                style: TextStyle(
                  fontSize: 14,
                  color: Styles.corLink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
