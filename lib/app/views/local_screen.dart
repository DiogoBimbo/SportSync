import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pi_app/app/components/barra_de_pesquisa.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/local.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({Key? key}) : super(key: key);

  @override
  _LocalScreenState createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Future<List<Local>> futureLocais;
  bool isLoading = true;
  String googleMapsUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  Future<void> openMap(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir $urlString';
    }
  }

  Future<void> openMapForLocation(double latitude, double longitude) async {
  String url = googleMapsUrl(latitude, longitude);
  await openMap(url);
}

  Future<List<Local>> fetchLocais() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Locais').get();
    setState(() {
      isLoading = false;
    });
    return querySnapshot.docs.map((doc) => Local.fromFirestore(doc)).toList();
  }

  Future<void> fetchLocationAndOpenMap(double latitude, double longitude) async {
    // Acessa a coleção 'Locais' do Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('Locais').get();

    // Aqui estamos assumindo que você quer abrir o primeiro local da lista
    // Modifique conforme necessário para o seu caso de uso específico
    if (querySnapshot.docs.isNotEmpty) {
      // Converte o primeiro documento para o objeto Local

      // Constrói a URL do Google Maps com as coordenadas
      String url = googleMapsUrl(latitude, longitude);

      // Abre o Google Maps
      await openMap(url);
    } else {
      print("Nenhum local encontrado no Firestore.");
    }
  }

  @override
  void initState() {
    super.initState();
    futureLocais = fetchLocais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostra o indicador de progresso enquanto carrega
          : SingleChildScrollView(
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
                    FutureBuilder<List<Local>>(
                      future: futureLocais,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}');
                        } else if (snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return const Text('Nenhum local encontrado.');
                        } else {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Local local = snapshot.data![index];
                              return PlaceCard(
                                imageUrl: local.imageUrl,
                                placeName: local.nome,
                                placeAddress: local.endereco,
                                // websiteLink: 'Localização',
                                // onLocationTap: () => fetchLocationAndOpenMap(local.latitude, local.longitude),
                              );
                            },
                          );
                        }
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
  // final String websiteLink;
  // final VoidCallback onLocationTap;

  const PlaceCard({
    Key? key,
    required this.imageUrl,
    required this.placeName,
    required this.placeAddress,
    // required this.websiteLink,
    // required this.onLocationTap,
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
                      const SizedBox(height: 8),
                      Text(
                        limitarString(placeAddress, 100),
                        style: Styles.texto,
                      ),
                      const SizedBox(height: 8),
                      // InkWell(
                      //   onTap: () {
                      //     onLocationTap;
                      //   },
                      //   child: const Row(
                      //     children: [
                      //       Icon(
                      //         Icons.location_on,
                      //         color: Styles.corLink, // Cor do ícone
                      //       ),
                      //       SizedBox(
                      //           width: 8,
                      //           height: 6), // Espaço entre o ícone e o texto
                      //       Text(
                      //         'Localização',
                      //         style: TextStyle(color: Styles.corLink),
                      //       ),
                      //     ],
                      //   ),
                      // )
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
