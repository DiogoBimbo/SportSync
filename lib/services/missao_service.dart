import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pi_app/app/models/missao_completada_model.dart';
import 'package:pi_app/app/models/missao_model.dart';

class MissoesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para buscar todas as missões disponíveis
  Future<List<Missao>> fetchMissoes() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Missoes').get();
    return querySnapshot.docs
        .map((doc) => Missao.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Método para buscar os IDs das missões completadas de um usuário específico
  Future<List<MissaoCompletada>> fetchMissoesCompletadas(String userId) async {
    try {
      QuerySnapshot missoesCompletadasSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('MissoesCompletadas')
          .get();

      List<MissaoCompletada> missoesCompletadas = [];

      for (var doc in missoesCompletadasSnapshot.docs) {
        String idMissao = doc['missaoId'];
        String idGrupo = doc['grupoId'];

        DocumentSnapshot missaoDoc = await _firestore.collection('Missoes').doc(idMissao).get();
        Missao missao = Missao.fromMap(missaoDoc.data() as Map<String, dynamic>, missaoDoc.id);

        missoesCompletadas.add(MissaoCompletada.fromDocument(doc, missao));
      }

      return missoesCompletadas;
    } catch (e) {
      throw Exception('Erro ao buscar missões completadas: $e');
    }
  }
}