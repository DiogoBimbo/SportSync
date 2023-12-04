import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pi_app/app/models/group.dart';
import 'package:pi_app/app/models/users.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadGroupImage(String path) async {
    File file = File(path);
    try {
      String fileName = path.split('/').last;
      Reference ref = _storage.ref().child('groupImages/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Error uploading group image: ${e.message}');
    }
  }

  Future<DocumentReference> createGroup({
    required String name,
    required List<User> members,
  }) async {
    auth.User? adminUser = auth.FirebaseAuth.instance.currentUser;
    if (adminUser == null) {
      throw Exception('Admin user not found');
    }

    // Inicializar a lista de membros com o admin
    Map<String, String> membersWithStatus = {adminUser.uid: 'admin'};

    // Adicionar os outros membros como 'normal'
    for (var member in members) {
      membersWithStatus[member.id] = 'normal';
    }

    DocumentReference groupDocRef = _firestore.collection('Groups').doc();

    await groupDocRef.set({
      'name': name,
      'admin': adminUser.uid,
      'membersWithStatus': membersWithStatus,
      'imageUrl': null, // inicialmente, a URL da imagem é nula
      'createdAt': FieldValue.serverTimestamp(),
    });

    return groupDocRef; // Retorna a referência do documento criado
  }

  Future<Group> getGroupById(String groupId) async {
    DocumentSnapshot groupDoc = await _firestore.collection('Groups').doc(groupId).get();
    if (!groupDoc.exists) {
      throw Exception('Grupo não encontrado');
    }
    return Group.fromDocument(groupDoc);
  }


  Future<List<User>> getGroupMembers(Group group) async {
    List<User> members = [];
    // Obtenha a lista de IDs dos membros do mapa 'membersWithStatus'
    List<String> memberIds = group.membersWithStatus.keys.toList();
    
    for (String memberId in memberIds) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(memberId).get();
      if (userDoc.exists) {
        members.add(User.fromDocument(userDoc));
      }
    }
    return members;
  }
  
}
