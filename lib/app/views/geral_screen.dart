import 'package:flutter/material.dart';

List<String> titles = <String>['Grupos', 'Amigos', 'Locais', 'Missões'];

class GeralScreen extends StatelessWidget {
  const GeralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 4;

    return DefaultTabController(
      initialIndex: 0,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nome do App'), // Editar nome do app
          actions: [
            IconButton(
              icon: const CircleAvatar(
                  backgroundImage: AssetImage(
                      'usuario.png') // Colocar a imagem do usuário integrado com backend
                  ),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
                // Página de grupos (importar aqui)
                ),
            ListView(
                // Página de amigos (importar aqui)
                ),
            ListView(
                // Página de locais (importar aqui)
                ),
            ListView(
                // Página de missões (importar aqui)
                ),
          ],
        ),
        bottomNavigationBar: Material(
          elevation: 5.0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.groups),
                  text: titles[0],
                ),
                Tab(
                  icon: const Icon(Icons.people),
                  text: titles[1],
                ),
                Tab(
                  icon: const Icon(Icons.location_on),
                  text: titles[2],
                ),
                Tab(
                  icon: const Icon(Icons.assignment),
                  text: titles[3],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
