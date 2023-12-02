import 'package:cloud_firestore/cloud_firestore.dart';

class Friendship {
  String friendId;

  Friendship({required this.friendId});

  factory Friendship.fromDocument(DocumentSnapshot doc) {
    return Friendship(
      friendId: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // Se necessário, adicione detalhes que você quer armazenar sobre a amizade
    };
  }
}