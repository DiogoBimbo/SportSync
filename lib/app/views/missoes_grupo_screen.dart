import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/informacoes_grupo_screen.dart';

class MissoesGrupoScreen extends StatefulWidget {
  const MissoesGrupoScreen({Key? key}) : super(key: key);

  @override
  _MissoesGrupoScreenState createState() => _MissoesGrupoScreenState();
}

class _MissoesGrupoScreenState extends State<MissoesGrupoScreen> {
  bool _mostraCompletas = false;
  bool _mostrarTodas = true;
  final List<Map<String, dynamic>> missoes = [
    {
      "dificuldade": "fácil",
      "esporte": "basquete",
      "pontos": 8,
      "nome": "Nome da missão",
      "descricao":
          "Descrição da missão: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "completa": false,
      "expanded": false,
    },
    {
      "dificuldade": "médio",
      "esporte": "futebol",
      "pontos": 16,
      "nome": "Nome da missão",
      "descricao":
          "Descrição da missão: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "completa": false,
      "expanded": false,
    },
    {
      "dificuldade": "difícil",
      "esporte": "tênis",
      "pontos": 32,
      "nome": "Nome da missão",
      "descricao":
          "Descrição da missão: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "completa": false,
      "expanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: kToolbarHeight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InformacoesGrupoScreen(
                      usuarioEhDono:
                          true, // implementar a obtenção do status de dono do grupo do banco de dados
                      nomeDoGrupo:
                          'Nome do grupo', // implementar a obtenção do nome do grupo do banco de dados
                      imagemDoGrupo:
                          'https://via.placeholder.com/150' // implementar a obtenção da imagem do grupo do banco de dados
                      ),
                ),
              );
            },
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('URL_DA_IMAGEM_DO_GRUPO'),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome do Grupo', style: Styles.tituloBarra),
                    SizedBox(height: 1.0),
                    Text('Toque para dados do grupo', style: Styles.conteudo),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InformacoesGrupoScreen(
                      usuarioEhDono:
                          true, // implementar a obtenção do status de dono do grupo do banco de dados
                      nomeDoGrupo:
                          'Nome do grupo', // implementar a obtenção do nome do grupo do banco de dados
                      imagemDoGrupo:
                          'https://via.placeholder.com/150' // implementar a obtenção da imagem do grupo do banco de dados
                      ),
                ),
              );
            },
          ),
        ],
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
              _buildMissoesSection(),
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

    final int minhaPosicao = 4; // Sua posição no ranking
    final int meusPontos = 50; // Seus pontos

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
            // Navegar para a tela de RankingScreen
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volcano,
                  color: Styles
                      .corLink), // Substitua Icons.star pelo ícone que você deseja usar
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
    double avatarRadius = isTopRanker ? 48 : 32; // Maior para o topo do ranking

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
        posicaoCor = Colors.grey; // Para outros rankings, caso necessário
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: posicaoCor.withOpacity(0.5),
              backgroundImage: NetworkImage(
                  'url_da_imagem'), // Substituir pela URL da imagem do usuário
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
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    '$posicao',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  Widget _buildMissoesSection() {
    return Column(
      children: [
        const Text('MISSÕES', style: Styles.titulo),
        const SizedBox(height: 20),
        const BarraPesquisa(hintText: 'pesquisar'),
        _buildFilterChips(),
        const SizedBox(height: 20),
        ...missoes.map(_buildMissaoCard).toList(),
      ],
    );
  }

  Widget _buildMissaoCard(Map<String, dynamic> missao) {
    double opacity = missao["completa"] ? 0.5 : 1.0;

    return Card(
      color: missao["completa"]
          ? const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5)
          : Colors.grey[800],
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          initiallyExpanded: missao["expanded"],
          onExpansionChanged: (bool expanded) {
            setState(() {
              missao["expanded"] = expanded;
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
                      missao["dificuldade"], missao["esporte"]),
                  const Spacer(),
                  Text('${missao["pontos"]} pts', style: Styles.textoDestacado),
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        missao["nome"],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: missao["completa"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Icon(
                        missao["expanded"]
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
          trailing: SizedBox.shrink(),
          children: [
            Opacity(
              opacity: opacity,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  missao["descricao"],
                ),
              ),
            ),
            // O botão será desativado se a missão estiver completa.
            if (!missao["completa"])
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      missao["completa"] = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.corPrincipal,
                  ),
                  child: const Text(
                    'Completar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
      case "médio":
        return Styles.corMedio;
      case "difícil":
        return Styles.corDificil;
      default:
        return Colors.grey; // Cor padrão
    }
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        ChoiceChip(
          label: const Text('Todas',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter')),
          selected: _mostrarTodas,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _mostrarTodas = true;
                _mostraCompletas = false; // Desativa os outros filtros
              }
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          selectedColor: Styles.corPrincipal,
          disabledColor: Colors.grey,
          avatar: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: const Icon(Icons.all_inclusive),
          ),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Completas',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter')),
          selected: !_mostrarTodas && _mostraCompletas,
          onSelected: (bool selected) {
            setState(() {
              _mostrarTodas = false;
              _mostraCompletas = selected;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          selectedColor: Colors.green[700],
          disabledColor: Colors.grey,
          avatar: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: const Icon(Icons.check),
          ),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Incompletas',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter')),
          selected: !_mostrarTodas && !_mostraCompletas,
          onSelected: (bool selected) {
            setState(() {
              _mostrarTodas = false;
              _mostraCompletas = !selected;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          selectedColor: Colors.red[400],
          disabledColor: Colors.grey,
          avatar: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: const Icon(Icons.close),
          ),
        ),
        // Adicione outros filtros se necessário
      ],
    );
  }
}
