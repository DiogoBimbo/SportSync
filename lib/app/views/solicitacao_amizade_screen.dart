import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/conta_amigo_screen.dart';
import 'package:pi_app/services/user_service.dart';

class SolicitacoesDeAmizadeScreen extends StatefulWidget {
  const SolicitacoesDeAmizadeScreen({Key? key}) : super(key: key);

  @override
  _SolicitacoesDeAmizadeScreenState createState() =>
      _SolicitacoesDeAmizadeScreenState();
}

class _SolicitacoesDeAmizadeScreenState
    extends State<SolicitacoesDeAmizadeScreen> {
  final UserService _userService = UserService();
  List<User> solicitacoes =
      []; // Lista para armazenar solicitações de amizade pendentes

  @override
  void initState() {
    super.initState();
    fetchPendingFriendRequests();
  }

  void fetchPendingFriendRequests() async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      List<User> friendRequests =
          await _userService.fetchFriendRequests(currentUserId);
      setState(() {
        solicitacoes = friendRequests;
      });
    } catch (e) {
      print('Erro ao buscar solicitações de amizade: $e');
    }
  }

  void acceptFriendRequest(String fromUserId) async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    await _userService.acceptFriendRequest(fromUserId, currentUserId);
    fetchPendingFriendRequests(); // Atualiza a lista após aceitar a solicitação
  }

  void declineFriendRequest(String fromUserId) async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    await _userService.declineFriendRequest(fromUserId, currentUserId);
    fetchPendingFriendRequests(); // Atualiza a lista após recusar a solicitação
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitações de amizade',
          style: Styles.tituloBarra,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: solicitacoes.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não possui nenhuma solicitação de amizade :(',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${solicitacoes.length} ${solicitacoes.length == 1 ? 'solicitação pendente' : 'solicitações pendentes'}',
                        style: Styles.texto,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: solicitacoes.length,
                      itemBuilder: (context, index) {
                        return _buildSolicitacaoItem(index);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSolicitacaoItem(int index) {
    User user = solicitacoes[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AmigoContaScreen(
          //       nomeAmigo: user.id,
          //       imagemDoAmigo: 'https://via.placeholder.com/150',
          //       eloDoAmigo: 'Elo', // Substitua com o elo real, se aplicável
          //       missoesCumpridas: 120, // Substitua com os dados reais
          //       missoesFaceis: 25,
          //       missoesMedias: 73,
          //       missoesDificeis: 22,
          //     ),
          //   ),
          // );
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(user.photo),
          ),
          title: Text(
            limitarString(user.name, 25),
            style: Styles.textoDestacado,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => declineFriendRequest(user.id),
                icon: Icon(
                  Icons.close,
                  color: Colors.red[400],
                ),
              ),
              IconButton(
                onPressed: () => acceptFriendRequest(user.id),
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
