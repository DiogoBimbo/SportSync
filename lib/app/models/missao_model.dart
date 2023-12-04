class Missao {
  final String id;
  final String nome;
  final int pontos;
  final String descricao;
  final String iconeEsporte;
  final String esporte;
  final String nivelMissao;
  final bool expanded;
  // Outros campos conforme necessário

  Missao({
    required this.id,
    required this.nome,
    required this.pontos,
    required this.descricao,
    required this.iconeEsporte,
    required this.esporte,
    required this.nivelMissao,
    required this.expanded,
    // Inicializar outros campos aqui
  });

  // Método para criar uma instância de Missao a partir de um Map (document do Firestore)
  factory Missao.fromMap(Map<String, dynamic> map, String documentId) {
    return Missao(
      id: documentId,
      nome: map['nome_missao'] as String,
      pontos: map['pontos'] as int,
      descricao: map['descricao'] as String,
      iconeEsporte: map['icone_esporte'] as String,
      esporte: map['esporte'] as String,
      nivelMissao: map['nivel_missao'] as String,
      expanded: false,
      // Inicializar outros campos aqui
    );
  }
}