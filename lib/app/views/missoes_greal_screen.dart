import 'package:flutter/material.dart';
import 'package:pi_app/app/components/missoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/ranking_screen.dart';

class MissoesGeralScreen extends StatefulWidget {
  const MissoesGeralScreen({Key? key}) : super(key: key);

  @override
  _MissoesGeralScreenState createState() => _MissoesGeralScreenState();
}

class _MissoesGeralScreenState extends State<MissoesGeralScreen> {
  String? selectedGroupName;
  List<Map<String, dynamic>> grupos = [
    {"nome": "Grupo A", "imagem": "https://via.placeholder.com/150"},
    {"nome": "Grupo B", "imagem": "https://via.placeholder.com/150"},
    {"nome": "Grupo C", "imagem": "https://via.placeholder.com/150"},
    {"nome": "Grupo D", "imagem": "https://via.placeholder.com/150"},
    {"nome": "Grupo E", "imagem": "https://via.placeholder.com/150"},
  ];

  @override
  void initState() {
    super.initState();
    if (grupos.isNotEmpty) {
      selectedGroupName = grupos.first["nome"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MINHAS MISSÕES',
                    style: Styles.tituloForte,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedGroupName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800], // Cor de fundo do campo
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Bordas arredondadas
                    borderSide: BorderSide.none, // Sem borda visível
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                ),
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.white), // Ícone de seta para baixo
                items: grupos.map((Map<String, dynamic> grupo) {
                  return DropdownMenuItem<String>(
                    value: grupo["nome"],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(grupo["imagem"]),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          grupo["nome"],
                          style: Styles.textoDestacado, // Estilo do texto
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGroupName = newValue;
                  });
                },
                style: Styles.textoDestacado,
                dropdownColor: Colors.grey[800],
              ),
              const SizedBox(height: 20),
              _buildRankingSection(),
              const SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey[400]),
              const SizedBox(height: 20),
              const MissoesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingSection() {
    int minhaPosicao = 4; // Sua posição no ranking
    int meusPontos = 50; // Seus pontos

    return Column(
      children: [
        const Text('RANKING', style: Styles.titulo),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Substitua pela URL da imagem do usuário
            ),
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
                builder: (context) => const RankingScreen(),
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
