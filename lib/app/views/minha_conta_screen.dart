import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pi_app/app/styles/styles.dart';
import 'package:pi_app/app/views/home_screen.dart';
import 'package:pi_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class MinhaContaScreen extends StatefulWidget {
  const MinhaContaScreen({Key? key}) : super(key: key);

  @override
  _MinhaContaScreenState createState() => _MinhaContaScreenState();
}

class _MinhaContaScreenState extends State<MinhaContaScreen> {
  TextEditingController nomeController = TextEditingController();
  String user = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  String nomeDoUsuario = '';
  String eloDoUsuario = '';
  String imagemElo = '';
  Map<String, int> totalMissoesCompletadas = {};
  File? imagemDoUsuario;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool editandoNome = false;
  bool isLoading = true;
  bool isLoadingCard = true;

  void fetchUserData() async {
    String userId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nomeDoUsuario = userData['name'] ?? 'Nome não encontrado';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _escolherImagem() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagemDoUsuario = File(image.path);
      });
    }
  }

  Future<String> uploadUserImage(String path) async {
    File file = File(path);
    try {
      String fileName = 'userImages/${path.split('/').last}';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception(
          'Erro ao fazer upload da imagem do usuário: ${e.message}');
    }
  }

  Future<void> _salvarAlteracoes() async {
    String userId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    String novoNome = nomeController.text.trim();
    String novaImagemUrl = '';

    if (imagemDoUsuario != null) {
      novaImagemUrl = await uploadUserImage(imagemDoUsuario!.path);
    }

    await _firestore.collection('Users').doc(userId).update({
      'name': novoNome,
      'photo': novaImagemUrl.isNotEmpty ? novaImagemUrl : '',
    });

    reloadPageData();
  }

  Future<void> atualizarDadosUser() async {
    String nomeUsuario = nomeController.text.trim();
    String? imageUrl;
    if (nomeUsuario.isEmpty) {
      // Mostrar erro se o nome do grupo estiver vazio
      return;
    }
    try {
      if (imagemDoUsuario != null) {
        // Se uma nova imagem foi selecionada, faça o upload
        imageUrl = await uploadUserImage(imagemDoUsuario!.path);
      }

      // Atualize o registro do grupo com o novo nome e a nova imagem (se houver)
      FirebaseFirestore.instance.collection('Users').doc(user).update({
        'name': nomeUsuario,
        'imageUrl': imageUrl,
      });

      Navigator.of(context).pop();
      // Mostrar confirmação e retornar para a tela anterior
    } catch (e) {
      print('Erro ao salvar alterações: $e');
      // Mostrar erro
    }
  }

  Future<Map<String, int>> contarMissoesCompletadas(String userId) async {
    int missoesFaceis = 0, missoesMedias = 0, missoesDificeis = 0;

    try {
      QuerySnapshot missoesCompletadasSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('MissoesCompletadas')
          .get();

      for (var doc in missoesCompletadasSnapshot.docs) {
        String missaoId = doc['missaoId'];
        DocumentSnapshot missaoDoc =
            await _firestore.collection('Missoes').doc(missaoId).get();

        if (missaoDoc.exists) {
          String dificuldade =
              missaoDoc['nivel_missao']; // Substitua pelo campo de dificuldade
          if (dificuldade == 'fácil') {
            missoesFaceis++;
          } else if (dificuldade == 'média') {
            missoesMedias++;
          } else if (dificuldade == 'difícil') {
            missoesDificeis++;
          }
        }
      }

      return {
        'Faceis': missoesFaceis,
        'Medias': missoesMedias,
        'Dificeis': missoesDificeis
      };
    } catch (e) {
      throw Exception('Erro ao contar missões completadas: $e');
    }
  }

  Future<Map<String, String>> determinarEloDoUsuario(
      int totalMissoesCompletadas) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Elos').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> eloData = doc.data() as Map<String, dynamic>;
        int minMissoes = eloData['qtd_missao_min'];
        int maxMissoes = eloData['qtd_missao_max'];
        String nomeElo = eloData['nome'];
        String imagemElo = eloData['img_elo'];

        if (totalMissoesCompletadas >= minMissoes &&
            totalMissoesCompletadas <= maxMissoes) {
          return {'nomeElo': nomeElo, 'imagemElo': imagemElo};
        }
      }

      return {'nomeElo': 'Elo não encontrado', 'imagemElo': ''};
    } catch (e) {
      throw Exception('Erro ao determinar o elo do usuário: $e');
    }
  }

  void _carregarDadosDoUsuario() async {
    String user = FirebaseAuth.instance.currentUser?.uid ?? '';
    totalMissoesCompletadas = await contarMissoesCompletadas(user);
    Map<String, String> eloInfo = await determinarEloDoUsuario(
        totalMissoesCompletadas['Faceis']! +
            totalMissoesCompletadas['Medias']! +
            totalMissoesCompletadas['Dificeis']!);

    setState(() {
      eloDoUsuario = eloInfo['nomeElo'] ?? '';
      imagemElo = eloInfo['imagemElo'] ?? '';
      isLoadingCard = false;
    });
  }

  void reloadPageData() {
    // Esta função é chamada para recarregar os dados da página.
    fetchUserData();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _carregarDadosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Conta',
          style: Styles.tituloBarra,
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostra o indicador de progresso enquanto carrega
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagem do usuário com ícone de câmera
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[700],
                          ),
                          child: imagemDoUsuario == null
                              ? Icon(
                                  Icons.account_circle,
                                  size: 120,
                                  color: Colors.grey[300],
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Styles.corPrincipal,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              color: Colors.white,
                              onPressed: () {
                                _escolherImagem();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    // Nome do usuário com ícone de lápis
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: editandoNome
                                ? TextField(
                                    controller: nomeController,
                                    style: Styles.textoDestacado,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome',
                                      hintText: 'Novo Nome',
                                      hintStyle: Styles.textoDestacado,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      filled: true,
                                    ),
                                  )
                                : Text(
                                    nomeDoUsuario, // implementar o nome do usuário
                                    textAlign: TextAlign.center,
                                    style: Styles.titulo,
                                  ),
                          ),
                          if (!editandoNome)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  editandoNome = !editandoNome;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    // Card de Estatísticas
                    isLoadingCard
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Mostra o indicador de progresso enquanto carrega
                        : SizedBox(
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('ESTATÍSTICAS',
                                        style: Styles.titulo),
                                    const SizedBox(height: 15.0),
                                    // Imagem de Estatísticas
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          imagemElo, // Substitua pela imagem real
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    // Título do Elo
                                    Text(eloDoUsuario,
                                        style: Styles
                                            .tituloBarra), // cor do texto mudar de acordo com o elo
                                    const SizedBox(height: 20.0),
                                    // Missões Cumpridas
                                    RichText(
                                      text: TextSpan(
                                        style: Styles.textoMaior,
                                        children: <TextSpan>[
                                          const TextSpan(text: 'Você cumpriu '),
                                          TextSpan(
                                              text:
                                                  '${totalMissoesCompletadas.values.fold(0, (a, b) => a + b)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const TextSpan(text: ' missões!'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    // Missões Fáceis
                                    SizedBox(
                                      height: 40.0,
                                      width: 180.0,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Styles.corFacil,
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                style: Styles.texto,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${totalMissoesCompletadas['Faceis']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const TextSpan(
                                                      text: ' missões fáceis'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    SizedBox(
                                      height: 40.0,
                                      width: 180.0,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Styles.corMedio,
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                style: Styles.texto,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${totalMissoesCompletadas['Medias']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const TextSpan(
                                                      text: ' missões médias'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    SizedBox(
                                      height: 40.0,
                                      width: 180.0,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Styles.corDificil,
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                style: Styles.texto,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${totalMissoesCompletadas['Dificeis']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const TextSpan(
                                                      text:
                                                          ' missões difíceis'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _salvarAlteracoes();
                            // snackbar custom
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.corPrincipal,
                            padding: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                color: Styles.corPrincipal,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Text(
                              'Salvar alterações',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton.icon(
                          onPressed: () async {
                            try {
                              await context.read<AuthService>().logout();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Erro ao sair: ${error.toString()}')),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.red[400],
                          ),
                          label: Text(
                            'Sair da Conta',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(
                                12.0), // Padding interno de 12
                            side: const BorderSide(
                                color: Color.fromRGBO(239, 83, 80, 1),
                                width: 2),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}