import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/styles/styles.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0, top: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'LOCAIS RECOMENDADOS',
                  style: Styles.titulo,
                ),
              ),
            ),
            const BarraPesquisa(hintText: 'Pesquisar por locais...'),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Número de locais na lista
                itemBuilder: (context, index) {
                  return const PlaceCard(
                    // imageUrl: 'https://pbs.twimg.com/media/FV9_kw-WYAAnZaG.jpg',
                    imageUrl: 'https://meulugar.quintoandar.com.br/wp-content/uploads/2023/08/o-que-fazer-no-parque-ibirapuera.jpeg',
                    priceTag: 'gratuito',
                    placeName: 'Nome do Lugar',
                    placeAddress: 'Endereço do Lugar',
                    websiteLink: 'https://google.com.br',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String priceTag;
  final String placeName;
  final String placeAddress;
  final String websiteLink;
  

  const PlaceCard({super.key, 
    required this.imageUrl,
    required this.priceTag,
    required this.placeName,
    required this.placeAddress,
    required this.websiteLink,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Coluna esquerda com a imagem (1/3)
          SizedBox(
            width: MediaQuery.of(context).size.width / 3, // 1/3 da largura da tela
            height: MediaQuery.of(context).size.width / 2,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          // Coluna direita com detalhes (2/3)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF3427C2)),
                      color: const Color(0xFF3427C2), // Cor de fundo da tag de preço
                      borderRadius: BorderRadius.circular(5.0), // Bordas arredondadas
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0), // Espaçamento interno
                      child: Text(
                        priceTag,
                        style: Styles.tag,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(placeName,
                    style: Styles.titulo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(placeAddress),
                ),
                Padding(
  padding: const EdgeInsets.all(0),
  child: TextButton(
    onPressed: () {
      // Adicione a ação desejada ao pressionar o link
      // Por exemplo, abrir um navegador com o link
    },
    child: Row(
      children: [
        Icon(
          Icons.location_on, // Ícone de localização (pode ser ajustado para o ícone desejado)
          color: Color.fromARGB(255, 124, 112, 255), // Cor do ícone
        ),
        const SizedBox(width: 8), // Espaçamento entre o ícone e o texto
        const Text(
          'Localização',
          style: TextStyle(color: Color.fromARGB(255, 124, 112, 255)),
        ),
      ],
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
