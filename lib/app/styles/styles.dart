import 'package:flutter/material.dart';

// Títulos grandes: 28 a 32 pontos em Inter
// Títulos médios: 20 a 24 pontos em Inter
// Texto de conteúdo: 14 a 18 pontos em Inter
// Texto pequeno (rodapé, legenda): 12 a 14 pontos em Inter

class Styles {
  static const TextStyle adcAmigos = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoDestacado = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle texto = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle subtitulo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titulo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tituloBarra = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle conteudo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle tag = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const Color corPrincipal = Color.fromARGB(255, 52, 39, 194);
  static const inputBorderLogin = BorderRadius.all(Radius.circular(50));
}
