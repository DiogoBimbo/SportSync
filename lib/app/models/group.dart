import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  late String id;
  late String name;
  late String imageUrl;
  late String admin;
  late Timestamp createdAt;
  late Map<String, String>
      membersWithStatus; // Representa os membros e seus status

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.admin,
    required this.createdAt,
    required this.membersWithStatus,
  });

  factory Group.fromDocument(DocumentSnapshot doc) {
    return Group(
      id: doc.id,
      name: doc['name'],
      imageUrl: doc['imageUrl'] ??
          '', // Use um valor padrão se a imagem não estiver presente
      admin: doc['admin'],
      createdAt: doc['createdAt'] ?? Timestamp.now(),
      membersWithStatus:
          Map<String, String>.from(doc['membersWithStatus'] ?? {}),
    );
  }

  bool isUserAdmin(String userId) {
    return admin == userId;
  }
}
