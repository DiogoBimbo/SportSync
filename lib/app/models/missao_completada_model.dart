import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pi_app/app/models/missao_model.dart';

class MissaoCompletada {
  final String idMissao;
  final String idGrupo;
  final Missao missao;

  MissaoCompletada({
    required this.idMissao,
    required this.idGrupo,
    required this.missao,
  });

  // Adicione um método para converter um DocumentSnapshot em uma instância de MissaoCompletada se necessário
  static MissaoCompletada fromDocument(DocumentSnapshot doc, Missao missao) {
    var data = doc.data() as Map<String, dynamic>;
    return MissaoCompletada(
      idMissao: data['missaoId'] as String,
      idGrupo: data['grupoId'] as String,
      missao: missao,
    );
  }
}