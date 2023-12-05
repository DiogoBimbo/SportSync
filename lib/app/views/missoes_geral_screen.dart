// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pi_app/app/components/missoes.dart';
// import 'package:pi_app/app/models/group.dart';
// import 'package:pi_app/app/styles/styles.dart';
// import 'package:pi_app/app/views/criar_grupo_participantes_screen.dart';
// import 'package:pi_app/app/views/ranking_screen.dart';
// import 'package:pi_app/services/group_service.dart';
// import 'package:pi_app/services/missao_service.dart';

// class MissoesGeralScreen extends StatefulWidget {
//   final String? groupId;

//   const MissoesGeralScreen({Key? key, this.groupId}) : super(key: key);

//   @override
//   _MissoesGeralScreenState createState() => _MissoesGeralScreenState();
// }

// class _MissoesGeralScreenState extends State<MissoesGeralScreen> {
//   String currentUserId =
//       FirebaseAuth.instance.currentUser?.uid ?? 'default_user_id';
//   final GroupService _groupService = GroupService();
//   final MissoesService _missoesService = MissoesService();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, dynamic>? currentUserRanking;
//   String? selectedGroupName;
//   String? selectedGroupId;
//   List<Group> grupos = [];
//   bool isLoading = true;

//   void _fetchGroups() async {
//     try {
//       String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
//       QuerySnapshot groupSnapshot = await _firestore
//           .collection('Groups')
//           .where('membersWithStatus.$currentUserId', isNull: false)
//           .get();

//       List<Group> fetchedGroups =
//           groupSnapshot.docs.map((doc) => Group.fromDocument(doc)).toList();

//       setState(() {
//         grupos = fetchedGroups;
//         if (grupos.isNotEmpty) {
//           // Defina o grupo selecionado para o grupo passado como parâmetro ou o primeiro grupo da lista
//           selectedGroupId = widget.groupId ?? grupos[0].id;
//           selectedGroupName =
//               grupos.firstWhere((g) => g.id == selectedGroupId).name;
//           _updateRankingAndMissionsForSelectedGroup(); // Adicione esta chamada
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Erro ao buscar grupos: $e');
//     }
//   }

//   void _adicionarGrupo() {
//     setState(() {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const CriarGrupoPScreen(),
//       ));
//     });
//   }

//   void _updateRankingAndMissionsForSelectedGroup() {
//     if (selectedGroupId == null) {
//       print('Nenhum grupo selecionado');
//       return;
//     }

//     calcularRanking(
//         selectedGroupId!); // Chame calcularRanking com o ID do grupo
//     // Aqui você pode chamar qualquer método que atualize as missões para o grupo selecionado

//     // Atualizar as missões para o grupo selecionado
//     _missoesService.fetchMissoesCompletadasPorGrupo(
//         currentUserId, selectedGroupId!);
//   }

//   Future<void> calcularRanking(String groupId) async {
//     try {
//       // Busque os dados de ranking para o grupo especificado
//       QuerySnapshot rankingSnapshot = await _firestore
//           .collection('Groups')
//           .doc(groupId)
//           .collection('Ranking')
//           .orderBy('points', descending: true)
//           .get();

//       // Converta os documentos em uma lista de mapas
//       List<Map<String, dynamic>> rankingData = rankingSnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();

//       // Encontre a posição e os dados do usuário atual no ranking
//       Map<String, dynamic>? currentUserRankingData;
//       int rankPosition = 1;
//       for (var data in rankingData) {
//         if (data['userId'] == auth.FirebaseAuth.instance.currentUser?.uid) {
//           currentUserRankingData = data;
//           break;
//         }
//         rankPosition++;
//       }

//       // Atualize o estado com o ranking do usuário atual
//       setState(() {
//         // Supondo que 'position' e 'points' sejam as chaves corretas no seu Firestore
//         currentUserRanking = {
//           'points': currentUserRankingData?['points'],
//           'photoUrl': currentUserRankingData?['photoUrl'],
//         };
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Erro ao calcular ranking: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<int> getPontosTotais(String userId, String groupId) async {
//     // Busca todas as missões completadas do usuário para o grupo especificado
//     var missoesCompletadas =
//         await _missoesService.fetchMissoesCompletadasPorGrupo(userId, groupId);

//     // Somar os pontos de todas as missões completadas
//     int pontos = 0;
//     for (var missaoCompletada in missoesCompletadas) {
//       pontos += missaoCompletada.missao.pontos;
//     }

//     return pontos;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchGroups();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : grupos.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Você ainda não possui nenhum grupo :(',
//                         style: TextStyle(
//                             fontSize: 17,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w400),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               Styles.corPrincipal),
//                         ),
//                         onPressed: () {
//                           _adicionarGrupo();
//                         },
//                         child: const Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.add, color: Colors.white),
//                               SizedBox(width: 8.0),
//                               Text(
//                                 'Crie um grupo',
//                                 style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontSize: 14.0,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0, vertical: 20.0),
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               'MINHAS MISSÕES',
//                               style: Styles.tituloForte,
//                             ),
//                           ),
//                         ),
//                         DropdownButtonFormField<String>(
//                           value: selectedGroupName,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor:
//                                 Colors.grey[800], // Cor de fundo do campo
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   5.0), // Bordas arredondadas
//                               borderSide: BorderSide.none, // Sem borda visível
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 20.0, vertical: 20),
//                           ),
//                           icon: const Icon(Icons.arrow_drop_down,
//                               color: Colors.white),
//                           items: grupos.map((Group grupo) {
//                             return DropdownMenuItem<String>(
//                               value: grupo.id, // Use o ID do grupo como valor
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 12,
//                                     backgroundImage:
//                                         NetworkImage(grupo.imageUrl),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     grupo.name,
//                                     style: Styles.textoDestacado,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//     // Quando um novo item é selecionado, atualize o estado com o novo ID e nome do grupo
//     final newSelectedGroup = grupos.firstWhere((g) => g.id == newValue);
//     if(newSelectedGroup != null) {
//       setState(() {
//         selectedGroupId = newSelectedGroup.id;
//         selectedGroupName = newSelectedGroup.name;
//         // Atualize o ranking e as missões aqui
//         _updateRankingAndMissionsForSelectedGroup();
//       });
//     }
//   },
//                           style: Styles.textoDestacado,
//                           dropdownColor: Colors.grey[800],
//                         ),
//                         const SizedBox(height: 20),
//                         _buildRankingSection(),
//                         const SizedBox(height: 10),
//                         Divider(height: 1, color: Colors.grey[400]),
//                         const SizedBox(height: 20),
//                         MissoesWidget(groupId: selectedGroupId ?? ''),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }

//   Widget _buildRankingSection() {
//     int minhaPosicao = 4; // Sua posição no ranking
//     int meusPontos = 50; // Seus pontos

//     return Column(
//       children: [
//         const Text('RANKING', style: Styles.titulo),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 32,
//               backgroundImage: NetworkImage(currentUserRanking![
//                   'photoUrl']), // Substitua pela URL da imagem do usuário
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Você está em 2º lugar com ${currentUserRanking!['pontos']} pontos',
//           style: Styles.textoDestacado,
//         ),
//         const SizedBox(height: 10),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     RankingScreen(groupId: selectedGroupId ?? ''),
//               ),
//             );
//           },
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.volcano, color: Styles.corLink),
//               SizedBox(width: 8.0), // Espaço entre o ícone e o texto
//               Text(
//                 'Consultar ranking',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Styles.corLink,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
