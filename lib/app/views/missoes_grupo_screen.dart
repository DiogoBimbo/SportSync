import 'package:flutter/material.dart';
import 'package:pi_app/app/components/missoes.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/ranking_screen.dart';

class MissoesGrupoScreen extends StatefulWidget {
  const MissoesGrupoScreen({Key? key}) : super(key: key);

  @override
  _MissoesGrupoScreenState createState() => _MissoesGrupoScreenState();
}

class _MissoesGrupoScreenState extends State<MissoesGrupoScreen> {
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
            children: [
              _buildRankingSection(),
              const SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey[400]),
              const SizedBox(height: 20),
              MissoesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingSection() {
    // Mock de dados, substituir com seus dados reais
    final List<Map<String, dynamic>> ranking = [
      {"nome": "Juninho", "pontos": 77},
      {"nome": "Cleber", "pontos": 60},
      {"nome": "Melissa", "pontos": 56},
    ];

    int minhaPosicao = 4; // Sua posição no ranking
    int meusPontos = 50; // Seus pontos

    return Column(
      children: [
        const Text('RANKING', style: Styles.titulo),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUserRanking(ranking[1]["nome"], ranking[1]["pontos"], 2),
            _buildUserRanking(ranking[0]["nome"], ranking[0]["pontos"], 1,
                isTopRanker: true),
            _buildUserRanking(ranking[2]["nome"], ranking[2]["pontos"], 3),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Você está em $minhaPosicaoº lugar com $meusPontos pontos',
          style: Styles.textoDestacado,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RankingScreen(),
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

  Widget _buildUserRanking(String nome, int pontos, int posicao,
      {bool isTopRanker = false}) {
    Color posicaoCor;
    double avatarRadius = isTopRanker ? 48 : 38; // Maior para o topo do ranking

    switch (posicao) {
      case 1:
        posicaoCor = Styles.gold;
        break;
      case 2:
        posicaoCor = Styles.silver;
        break;
      case 3:
        posicaoCor = Styles.bronze;
        break;
      default:
        posicaoCor = Colors.grey;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: posicaoCor,
                child: CircleAvatar(
                  radius: avatarRadius - 3,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Substituir pela URL da imagem do usuário
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: posicaoCor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      '$posicaoº',
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
        Text(limitarString(nome, 10), style: Styles.textoDestacado),
        Text('$pontos pontos', style: Styles.texto),
      ],
    );
  }
}
