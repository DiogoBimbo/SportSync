import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/conta_amigo_screen.dart';

class SolicitacoesDeAmizadeScreen extends StatefulWidget {
  const SolicitacoesDeAmizadeScreen({Key? key}) : super(key: key);

  @override
  _SolicitacoesDeAmizadeScreenState createState() =>
      _SolicitacoesDeAmizadeScreenState();
}

class _SolicitacoesDeAmizadeScreenState
    extends State<SolicitacoesDeAmizadeScreen> {
  List<String> solicitacoes = [
    // Lista de solicitações de amizade para testes
    'João Carlinhos',
    'Maria Desgraçada',
    'Pedro Paulo',
    'Ana Julia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitações de amizade',
          style: Styles.tituloBarra,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: solicitacoes.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não possui nenhuma solicitação de amizade :(',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${solicitacoes.length} ${solicitacoes.length == 1 ? 'solicitação pendente' : 'solicitações pendentes'}',
                        style: Styles.texto,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: solicitacoes.length,
                      itemBuilder: (context, index) {
                        return _buildSolicitacaoItem(index);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSolicitacaoItem(int index) {
    String nomeDaPessoa = solicitacoes[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AmigoContaScreen(
                nomeAmigo: nomeDaPessoa,
                imagemDoAmigo: 'https://via.placeholder.com/150',
                eloDoAmigo: 'Elo', // Substitua com o elo real, se aplicável
                missoesCumpridas: 120, // Substitua com os dados reais
                missoesFaceis: 25,
                missoesMedias: 73,
                missoesDificeis: 22,
              ),
            ),
          );
        },
        child: ListTile(
          leading: const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text(
            limitarString(nomeDaPessoa, 25),
            style: Styles.textoDestacado,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Implementar lógica de recusar a solicitação
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red[400],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Implementar lógica de aceitar a solicitação
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
