import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pi_app/app/functions/funcoes.dart';
import 'package:pi_app/app/models/users.dart';
import 'package:pi_app/app/styles/styles.dart';
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
  bool isLoading = true; // Estado de carregamento adicionado

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
  }

  void _fetchFriendRequests() async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    List<User> friendRequests =
        await _userService.fetchFriendRequests(currentUserId);
    setState(() {
      solicitacoes = friendRequests;
      isLoading = false; // A busca foi completada
    });
  }

  void acceptFriendRequest(String fromUserId) async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    await _userService.acceptFriendRequest(fromUserId, currentUserId);
    _fetchFriendRequests(); // Atualiza a lista após aceitar a solicitação
  }

  void declineFriendRequest(String fromUserId) async {
    String currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    await _userService.declineFriendRequest(fromUserId, currentUserId);
    _fetchFriendRequests(); // Atualiza a lista após recusar a solicitação
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : solicitacoes.isEmpty
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
                : SingleChildScrollView(
                    child: Column(
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
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(user.photo),
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
              icon: const Icon(Icons.close,
                  color: Color.fromARGB(251, 239, 83, 80)),
            ),
            IconButton(
              onPressed: () => acceptFriendRequest(user.id),
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
