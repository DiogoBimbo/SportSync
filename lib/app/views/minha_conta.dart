import 'package:flutter/material.dart';

class MinhaContaScreen extends StatefulWidget {
  const MinhaContaScreen({Key? key}) : super(key: key);

  @override
  _MinhaContaScreenState createState() => _MinhaContaScreenState();
}

class _MinhaContaScreenState extends State<MinhaContaScreen> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  bool editandoNome = false;
  bool editandoEmail = false;
  bool editandoSenha = false;

  String imagemDoUsuario =
      'URL_DA_IMAGEM_DO_USUARIO'; // Substitua pela imagem real
  String eloDoUsuario = 'Elo do Usuário'; // Substitua pelo valor real
  int misssoesCumpridas = 10; // Substitua pelo valor real
  int missoesFaceis = 5; // Substitua pelo valor real
  int missoesMedias = 3; // Substitua pelo valor real
  int missoesDificeis = 2; // Substitua pelo valor real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MINHA CONTA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      image: DecorationImage(
                        image: NetworkImage(imagemDoUsuario),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        onPressed: () {
                          // Implemente a lógica para alterar a imagem
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Nome do usuário com ícone de lápis
              Row(
                children: [
                  Expanded(
                    child: editandoNome
                        ? TextField(
                            controller: nomeController,
                            decoration: InputDecoration(
                              hintText: 'Novo Nome',
                            ),
                          )
                        : Text(
                            'Nome do Usuário',
                            style: TextStyle(fontSize: 18.0),
                          ),
                  ),
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
              const SizedBox(height: 16.0),

              // Email do usuário com ícone de lápis
              Row(
                children: [
                  Expanded(
                    child: editandoEmail
                        ? TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Novo Email',
                            ),
                          )
                        : Text(
                            'email@exemplo.com',
                            style: TextStyle(fontSize: 18.0),
                          ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editandoEmail = !editandoEmail;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Senha do usuário com ícone de lápis
              Row(
                children: [
                  Expanded(
                    child: editandoSenha
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: senhaController,
                                decoration: const InputDecoration(
                                  hintText: 'Nova Senha',
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextField(
                                controller: confirmarSenhaController,
                                decoration: const InputDecoration(
                                  hintText: 'Confirmar Nova Senha',
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '************',
                            style: TextStyle(fontSize: 18.0),
                          ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editandoSenha = !editandoSenha;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Card de Estatísticas
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESTATÍSTICAS',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Imagem de Estatísticas
                      Image.network(
                        'URL_DA_IMAGEM_DE_ESTATISTICAS', // Substitua pela imagem real
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 16.0),
                      // Título do Elo
                      Text(
                        eloDoUsuario,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Missões Cumpridas
                      Text(
                        'Você cumpriu $misssoesCumpridas missões!',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      // Missões Fáceis
                      Text(
                        '$missoesFaceis missões fáceis',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      // Missões Médias
                      Text(
                        '$missoesMedias missões médias',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      // Missões Difíceis
                      Text(
                        '$missoesDificeis missões difíceis',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Botões para Salvar Alterações e Sair da Conta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implemente a lógica para salvar as alterações
                    },
                    child: const Text('Salvar Alterações'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implemente a lógica para sair da conta
                    },
                    child: const Text('Sair da Conta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
