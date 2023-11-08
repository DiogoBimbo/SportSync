import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class BarraPesquisa extends StatelessWidget {
  final String hintText;

  const BarraPesquisa({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        filled: true,
        prefixIcon: const Icon(Icons.search, color: Colors.white),
      ),
      style: Styles.textoDestacado,
    );
  }
}
