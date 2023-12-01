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

  // Enviar solicitação de amizade
  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    await _firestore
        .collection('Users')
        .doc(toUserId)
        .collection('FriendRequests')
        .doc(fromUserId)
        .set({
      'fromUserId': fromUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Buscar solicitações de amizade pendentes
  Future<List<User>> fetchFriendRequests(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('FriendRequests')
        .get();
    // Transforma os documentos em uma lista de IDs de usuários remetentes
    List<String> fromUserIds = querySnapshot.docs.map((doc) => doc.id).toList();
    // Agora, você pode buscar os dados de usuário completos se necessário
    List<User> usersList = await fetchUsersByIds(fromUserIds);
    return usersList;
  }

  // Aceitar solicitação de amizade
  Future<void> acceptFriendRequest(String fromUserId, String toUserId) async {
    // Adiciona o amigo em ambas as listas
    await _firestore
        .collection('Users')
        .doc(toUserId)
        .collection('Friends')
        .doc(fromUserId)
        .set({});
    await _firestore
        .collection('Users')
        .doc(fromUserId)
        .collection('Friends')
        .doc(toUserId)
        .set({});
    // Remove a solicitação pendente
    await _firestore
        .collection('Users')
        .doc(toUserId)
        .collection('FriendRequests')
        .doc(fromUserId)
        .delete();
  }

  // Recusar solicitação de amizade
  Future<void> declineFriendRequest(String fromUserId, String toUserId) async {
    await _firestore
        .collection('Users')
        .doc(toUserId)
        .collection('FriendRequests')
        .doc(fromUserId)
        .delete();
  }

  // Buscar usuários por IDs
  Future<List<User>> fetchUsersByIds(List<String> userIds) async {
    List<User> userList = [];
    for (String userId in userIds) {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('Users').doc(userId).get();
      userList.add(User.fromDocument(docSnapshot));
    }
    return userList;
  }
}
