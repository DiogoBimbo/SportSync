import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/styles/styles.dart';

class MissoesWidget extends StatefulWidget {
  const MissoesWidget({super.key});

  @override
  _MissoesWidgetState createState() => _MissoesWidgetState();
}

class _MissoesWidgetState extends State<MissoesWidget> {
  bool _mostraCompletas = false;
  bool _mostrarTodas = true;
  final List<Map<String, dynamic>> missoes = [
    {
      "dificuldade": "fácil",
      "esporte": "basquete",
      "pontos": 8,
      "nome": "Missão de Basquete",
      "descricao":
          "Esta é uma missão fácil de basquete. O objetivo é fazer cestas de 2 pontos.",
      "completa": false,
      "expanded": false,
    },
    {
      "dificuldade": "médio",
      "esporte": "futebol",
      "pontos": 16,
      "nome": "Desafio de Futebol",
      "descricao":
          "Esta é uma missão de dificuldade média de futebol. O objetivo é marcar gols e evitar que o adversário marque.",
      "completa": false,
      "expanded": false,
    },
    {
      "dificuldade": "difícil",
      "esporte": "tênis",
      "pontos": 32,
      "nome": "Torneio de Tênis",
      "descricao":
          "Esta é uma missão difícil de tênis. O objetivo é vencer um torneio de tênis contra adversários de alto nível.",
      "completa": false,
      "expanded": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildMissoesSection()],
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
          tilePadding: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 24),
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
                  Text(
                      missao["completa"]
                          ? '${missao["pontos"]} pts'
                          : '+ ${missao["pontos"]} pts',
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/150'),
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
          trailing: const SizedBox.shrink(),
          children: [
            Opacity(
              opacity: opacity,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 12.0),
                child: Text(
                  missao["descricao"],
                  textAlign: TextAlign.justify,
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
                    setState(() {
                      if (missao["completa"]) {
                        missao["completa"] = false;
                        _mostrarNotificacao(
                            missao["nome"], missao["pontos"], false);
                      } else {
                        missao["completa"] = true;
                        _mostrarNotificacao(
                            missao["nome"], missao["pontos"], true);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: missao["completa"]
                        ? const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5)
                        : Styles.corPrincipal,
                    side: missao["completa"]
                        ? const BorderSide(
                            color: Color.fromARGB(255, 239, 83, 80), width: 2)
                        : BorderSide.none,
                    // A borda aparece quando a missão estiver completa
                  ),
                  child: Text(
                    missao["completa"] ? 'Cancelar' : 'Completar',
                    style: TextStyle(
                      color:
                          missao["completa"] ? Colors.red[400] : Colors.white,
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
      case "médio":
        return Styles.corMedio;
      case "difícil":
        return Styles.corDificil;
      default:
        return Colors.grey; // Cor padrão
    }
  }

  Widget _buildFilterChips() {
    return SizedBox(
      child: 
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ChoiceChip(
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text('Todas',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter')),
              ),
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
              selectedColor: Colors.grey[900],
              disabledColor: Colors.grey,
              avatar: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.all_inclusive),
              ),
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text('Completas',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter')),
              ),
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
              selectedColor: Styles.corPrincipal,
              disabledColor: Colors.grey,
              avatar: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.check),
              ),
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text('Incompletas',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter')),
              ),
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
              avatar: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.close),
              ),
            ),
            // Adicione outros filtros se necessário
          ],
        ),
      ),
    );
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
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}