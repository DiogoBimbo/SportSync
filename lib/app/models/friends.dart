import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  String fromUserId;
  String toUserId;
  DateTime timestamp;

  FriendRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
  });

  factory FriendRequest.fromDocument(DocumentSnapshot doc) {
    return FriendRequest(
      fromUserId: doc['fromUserId'],
      toUserId: doc.id,
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'timestamp': timestamp,
    };
  }
}

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
