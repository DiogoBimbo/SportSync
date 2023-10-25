import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fundo_inicial.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.2),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              // Logo
              Align(
                alignment: Alignment.topCenter,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Frase de efeito e botões
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Desperte o atleta dentro de você e conquiste novos desafios!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        width: 350.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para o botão "Criar uma conta"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 52, 39, 194),
                            // Define a cor de fundo personalizada
                            foregroundColor: Colors.white,
                            // Define a cor do texto personalizada
                          ),
                          child: const Text(
                            'Criar uma conta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: 350.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para o botão "Já tenho uma conta"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Já tenho uma conta',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ],
      ),
    );
  }
}
