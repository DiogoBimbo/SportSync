import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';

class AmigoContaScreen extends StatelessWidget {
  final String nomeAmigo;
  final String imagemDoAmigo;
  final String eloDoAmigo;
  final int missoesCumpridas;
  final int missoesFaceis;
  final int missoesMedias;
  final int missoesDificeis;

  const AmigoContaScreen({
    Key? key,
    required this.nomeAmigo,
    required this.imagemDoAmigo,
    required this.eloDoAmigo,
    required this.missoesCumpridas,
    required this.missoesFaceis,
    required this.missoesMedias,
    required this.missoesDificeis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conta de ${limitarString(nomeAmigo, 20)}',
          style: Styles.tituloBarra,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagem do amigo sem ícone de câmera
              SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[700],
                    // ignore: unnecessary_null_comparison
                    image: imagemDoAmigo != null
                        ? DecorationImage(
                            image: NetworkImage(imagemDoAmigo),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              // Nome do amigo
              Center(
                child: Text(
                  nomeAmigo,
                  textAlign: TextAlign.center,
                  style: Styles.titulo,
                ),
              ),
              const SizedBox(height: 20.0),

              // Card de Estatísticas do amigo
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('ESTATÍSTICAS', style: Styles.titulo),
                        const SizedBox(height: 15.0),
                        // Imagem de Estatísticas do amigo
                        ClipOval(
                          child: Image.network(
                            'https://via.placeholder.com/150', // Substitua pela imagem real
                            width: 120,
                            height: 120,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // Título do Elo do amigo
                        Text(
                          eloDoAmigo,
                          style: Styles.tituloBarra,
                        ),
                        const SizedBox(height: 20.0),
                        // Missões Cumpridas do amigo
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: RichText(
                            text: TextSpan(
                              style: Styles.textoMaior,
                              children: <TextSpan>[
                                TextSpan(text: '$nomeAmigo cumpriu '),
                                TextSpan(
                                  text: '$missoesCumpridas',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' missões!'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        // Missões Fáceis do amigo
                        SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corFacil,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesFaceis',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' missões fáceis'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Missões Médias do amigo
                        SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corMedio,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesMedias',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' missões médias'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Missões Difíceis do amigo
                        SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corDificil,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesDificeis',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' missões difíceis'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
