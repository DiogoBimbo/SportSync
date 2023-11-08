import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar Locais',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Número de locais na lista
            itemBuilder: (context, index) {
              return PlaceCard(
                imageUrl: 'https://pbs.twimg.com/media/FV9_kw-WYAAnZaG.jpg',
                priceTag: 'gratuito',
                placeName: 'Nome do Lugar',
                placeAddress: 'Endereço do Lugar',
                websiteLink: 'https://google.com.br',
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String priceTag;
  final String placeName;
  final String placeAddress;
  final String websiteLink;
  

  PlaceCard({
    required this.imageUrl,
    required this.priceTag,
    required this.placeName,
    required this.placeAddress,
    required this.websiteLink,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Coluna esquerda com a imagem (1/3)
          Container(
            width: MediaQuery.of(context).size.width / 3, // 1/3 da largura da tela
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
                      border: Border.all(color: Colors.black),
                      color: const Color.fromARGB(255, 0, 0, 0), // Cor de fundo da tag de preço
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      // Adicione a ação desejada ao pressionar o link
                      // Por exemplo, abrir um navegador com o link
                    },
                    child: Text(
                      'Website',
                      style: TextStyle(color: Colors.blue),
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
