// funcão para limitar o tamanho de uma string
String limitarString(String texto, int limite) {
  if (texto.length <= limite) {
    return texto;
  } else {
    return "${texto.substring(0, limite)}...";
  }
}
