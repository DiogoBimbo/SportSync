import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

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
  String eloDoUsuario = 'Prata'; // Substitua pelo valor real
  int misssoesCumpridas =
      10; // Substitua pelo valor real - soma das missões fáceis, médias e difíceis
  int missoesFaceis = 5; // Substitua pelo valor real
  int missoesMedias = 3; // Substitua pelo valor real
  int missoesDificeis = 2; // Substitua pelo valor real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Conta',
          style: Styles.tituloBarra,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
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
                      // ignore: unnecessary_null_comparison
                      image: imagemDoUsuario != null
                          ? DecorationImage(
                              image: NetworkImage(imagemDoUsuario),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
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
                          // Implementar a ação de abrir a câmera
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
                              decoration: InputDecoration(
                                labelText: 'Nome',
                                hintText: 'Novo Nome',
                                hintStyle: Styles.textoDestacado,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      editandoNome = !editandoNome;
                                    });
                                  },
                                ),
                              ),
                            )
                          : const Text(
                              'Carlos Henrique', // implementar o nome do usuário
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
              // Email do usuário com ícone de lápis
              Row(
                children: [
                  Expanded(
                    child: editandoEmail
                        ? TextField(
                            controller: emailController,
                            style: Styles.textoDestacado,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Novo Email',
                              hintStyle: Styles.textoDestacado,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    editandoEmail = !editandoEmail;
                                  });
                                },
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.5, bottom: 3.5, left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                'Email@exemplo.com', // implementar o email do usuário
                                                style: Styles.textoDestacado,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  editandoEmail =
                                                      !editandoEmail;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),

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
                                style: Styles.textoDestacado,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  hintText: 'Nova Senha',
                                  hintStyle: Styles.textoDestacado,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.check),
                                    onPressed: () {
                                      setState(() {
                                        editandoSenha = !editandoSenha;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              TextField(
                                controller: confirmarSenhaController,
                                style: Styles.textoDestacado,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar Senha',
                                  hintText: 'Confirmar Nova Senha',
                                  hintStyle: Styles.textoDestacado,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.check),
                                    onPressed: () {
                                      setState(() {
                                        editandoSenha = !editandoSenha;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.5, bottom: 3.5, left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                '**************************', // implementar a senha do usuário só a qtd de caracteres como *
                                                style: Styles.textoDestacado,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  editandoSenha =
                                                      !editandoSenha;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Card de Estatísticas
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('ESTATÍSTICAS', style: Styles.titulo),
                        const SizedBox(height: 15.0),
                        // Imagem de Estatísticas
                        ClipOval(
                          child: Image.network(
                            'https://via.placeholder.com/150', // Substitua pela imagem real
                            width: 120,
                            height: 120,
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
                                  text: '$misssoesCumpridas',
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
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corFacil,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesFaceis',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: ' missões fáceis'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
// Missões Médias
                        SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corMedio,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesMedias',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: ' missões médias'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
// Missões Difíceis
                        SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Styles.corDificil,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: Styles.texto,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$missoesDificeis',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: ' missões difíceis'),
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
                  TextButton.icon(
                    onPressed: () {
                      // Implemente a lógica para sair da conta
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
                      padding:
                          const EdgeInsets.all(12.0), // Padding interno de 12
                      side: const BorderSide(
                          color: Color.fromRGBO(239, 83, 80, 1), width: 2),
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
