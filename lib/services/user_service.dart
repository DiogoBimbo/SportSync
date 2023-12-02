import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/databases/db_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = DBFirestore.get();

  Future<List<User>> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    } catch (e) {
      // Tratar erro ou reenviar
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    try {
      await _firestore.collection('Users').doc(toUserId).collection('FriendRequests').add({
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });
       await _firestore.collection('Users').doc(fromUserId).collection('FriendRequests').add({
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });
    } catch (e) {
      throw Exception('Erro ao enviar solicitação de amizade: $e');
    }
  }

  Future<List<User>> fetchFriendRequests(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('FriendRequests')
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

  

      List<User> friendRequests = [];
      for (var doc in querySnapshot.docs) {
        String fromUserId = doc['fromUserId'];
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(fromUserId).get();
        User user = User.fromDocument(userDoc);
        friendRequests.add(user);
      }

      return friendRequests;
    } catch (e) {
      throw Exception('Erro ao buscar solicitações de amizade: $e');
    }
  }

  // Aceitar solicitação de amizade
  Future<void> acceptFriendRequest(String fromUserId, String toUserId) async {
  // Adiciona o amigo em ambas as listas
  await _firestore.collection('Users').doc(toUserId).collection('Friends').doc(fromUserId).set({});
  await _firestore.collection('Users').doc(fromUserId).collection('Friends').doc(toUserId).set({});

  // Encontrar e remover a solicitação pendente
  QuerySnapshot snapshot = await _firestore
      .collection('Users')
      .doc(toUserId)
      .collection('FriendRequests')
      .where('fromUserId', isEqualTo: fromUserId)
      .get();

  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

  // Recusar solicitação de amizade
  Future<void> declineFriendRequest(String fromUserId, String toUserId) async {
    QuerySnapshot snapshot = await _firestore
      .collection('Users')
      .doc(toUserId)
      .collection('FriendRequests')
      .where('toUserId', isEqualTo: toUserId)
      .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> fetchUserFriends(String userId) async {
    try {
      QuerySnapshot friendsSnapshot = await _firestore.collection('Users')
          .doc(userId)
          .collection('Friends')
          .get();
      List<String> friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();
      return friendIds;
    } catch (e) {
      throw Exception('Erro ao buscar amigos: $e');
    }
  }

  Future<List<String>> fetchSentFriendRequests(String userId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('FriendRequests')
        .where('fromUserId', isEqualTo: userId)
        .get();

    List<String> requestedUserIds = [];
    for (var doc in querySnapshot.docs) {
      String toUserId = doc['toUserId'];
      requestedUserIds.add(toUserId);
    }

    return requestedUserIds;
      } catch (e) {
        throw Exception('Erro ao buscar solicitações de amizade enviadas: $e');
      }
    }

  Future<int> fetchNumberOfFriendRequests(String userId) async {
      try {
        // Buscar solicitações de amizade recebidas pendentes
        QuerySnapshot requestsSnapshot = await _firestore.collection('FriendRequests')
            .where('toUserId', isEqualTo: userId)
            .where('status', isEqualTo: 'pending')
            .get();

        // Retornar a contagem de documentos
        return requestsSnapshot.docs.length;
        } catch (e) {
          throw Exception('Erro ao buscar o número de solicitações de amizade: $e');
        }
    }


  Future<void> removeFriend(String currentUserId, String friendId) async {
    try {
      // Iniciar uma operação de lote para garantir que ambas as operações sejam realizadas juntas
      WriteBatch batch = _firestore.batch();

      // Referência ao documento do amigo na subcoleção 'Friends' do usuário logado
      DocumentReference friendRefCurrentUser = _firestore
          .collection('Users')
          .doc(currentUserId)
          .collection('Friends')
          .doc(friendId);

      // Referência ao documento do usuário logado na subcoleção 'Friends' do amigo
      DocumentReference friendRefFriend = _firestore
          .collection('Users')
          .doc(friendId)
          .collection('Friends')
          .doc(currentUserId);

      // Adicionar as operações de exclusão ao lote
      batch.delete(friendRefCurrentUser);
      batch.delete(friendRefFriend);

      // Cometer o lote
      await batch.commit();
      } catch (e) {
        throw Exception('Erro ao remover amigo: $e');
      }
  }

}
