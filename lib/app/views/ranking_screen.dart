import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final String currentUser = "Douglas"; // Substituir pelo nome do usuário atual
  List<Map<String, dynamic>> rankingData = [
    {"posicao": "1º", "nome": "Juninho", "pontos": 77},
    {"posicao": "2º", "nome": "Cleber", "pontos": 60},
    {"posicao": "3º", "nome": "Melissa", "pontos": 56},
    {"posicao": "4º", "nome": "Douglas", "pontos": 50},
    {"posicao": "5º", "nome": "Amanda", "pontos": 35},
    // Adicione mais dados conforme necessário
  ];

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
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Substituir pela URL da imagem do grupo
            ),
            SizedBox(width: 10),
            Text('Nome do Grupo',
                style: Styles.tituloBarra), // Substituir pelo nome do grupo
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                itemCount: rankingData.length,
                itemBuilder: (context, index) {
                  final item = rankingData[index];
                  final isCurrentUser = item["nome"] == currentUser;
                  bool showBorder =
                      ["1º", "2º", "3º"].contains(item["posicao"]);
                  Color borderColor = _getPointsColor(item["posicao"]);
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
                              item["posicao"],
                              style: Styles.tituloBarra.copyWith(
                                  color: _getPointsColor(item["posicao"])),
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
                                backgroundImage: const NetworkImage(
                                    'https://via.placeholder.com/150'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                isCurrentUser ? 'Você' : item["nome"],
                                style: Styles.textoDestacado.copyWith(
                                  color: _getPointsColor(item["posicao"]),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              '${item["pontos"]} pontos',
                              style: TextStyle(
                                color: _getPointsColor(item["posicao"]),
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
