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
}
