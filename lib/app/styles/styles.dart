import 'package:flutter/material.dart';

// Arquivo contendo estilos reutilizáveis - á definir(apagar comentários quando estiver pronto)
class Styles {
  // Texto da barra de AmigosInicialScreen
  static const TextStyle tituloBarra = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Texto da barra de pesquisa e dos nomes dos amigos na AmigosInicialScreen
  static const TextStyle subtitulo = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  // Texto em nenhuma tela por enquanto
  static const TextStyle texto = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const Color corPrincipal = Color.fromARGB(255, 52, 39, 194);
  static const inputBorderLogin = BorderRadius.all(Radius.circular(50));
}
