import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/styles/styles.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOCAIS RECOMENDADOS',
                    style: Styles.tituloForte,
                  ),
                ),
              ),
              const BarraPesquisa(hintText: 'Pesquisar por locais...'),
              const SizedBox(height: 20),
              ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Adiciona essa linha
                shrinkWrap: true, // Adiciona essa linha
                itemCount: 5, // Número de locais na lista
                itemBuilder: (context, index) {
                  return const PlaceCard(
                    imageUrl:
                        'https://meulugar.quintoandar.com.br/wp-content/uploads/2023/08/o-que-fazer-no-parque-ibirapuera.jpeg',
                    placeName: 'Parque Ibirapuera',
                    placeAddress: 'Av. Pedro Álvares Cabral 726 - Vila Mariana',
                    websiteLink: 'https://google.com.br',
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

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String placeName;
  final String placeAddress;
  final String websiteLink;

  const PlaceCard({
    Key? key,
    required this.imageUrl,
    required this.placeName,
    required this.placeAddress,
    required this.websiteLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        clipBehavior: Clip.antiAlias, // Adiciona clip para o borderRadius
        margin: const EdgeInsets.only(bottom: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Adiciona borderRadius ao Card
        ),
        child: Row(
          children: [
            // Coluna esquerda com a imagem (1/3)
            SizedBox(
              width: MediaQuery.of(context).size.width /
                  3, // 1/3 da largura da tela
              height: MediaQuery.of(context).size.width /
                  3, // 1/3 da largura da tela para uma imagem quadrada
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Coluna direita com detalhes (2/3)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, // Espaçamento igual entre os elementos
                    children: [
                      Text(
                        placeName,
                        style: Styles.titulo,
                        overflow: TextOverflow
                            .ellipsis, // Adiciona ellipsis para textos longos
                      ),
                      SizedBox(height: 8),
                      Text(
                        limitarString(placeAddress, 45),
                        style: Styles.texto,
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // Adicione a ação desejada ao pressionar
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Styles.corLink, // Cor do ícone
                            ),
                            SizedBox(
                                width: 8,
                                height: 6), // Espaço entre o ícone e o texto
                            Text(
                              'Localização',
                              style: TextStyle(color: Styles.corLink),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
