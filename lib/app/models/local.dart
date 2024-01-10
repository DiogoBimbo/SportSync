import 'package:cloud_firestore/cloud_firestore.dart';

class Local {
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String nome;
  final String endereco;

  Local({required this.latitude, 
        required this.longitude,
        required this.imageUrl,
        required this.nome,
        required this.endereco
        });

  // Construtor que converte os dados do Firestore em um objeto Local
  factory Local.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Local(
      imageUrl: data['img'] ?? '', // Coalescência nula aqui
      nome: data['nome'] ?? 'Nome indisponível', // E aqui
      endereco: data['endereco'] ?? 'Endereço indisponível', // E aqui
      latitude: (data['latitude'] is String) ? double.parse(data['latitude']) : (data['latitude'] ?? 0.0), // Conversão de String para double se necessário
      longitude: (data['longitude'] is String) ? double.parse(data['longitude']) : (data['longitude'] ?? 0.0), // Conversão de String para double se necessário
    );
  }
}
