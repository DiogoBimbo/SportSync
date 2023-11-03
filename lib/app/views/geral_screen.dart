import 'package:flutter/material.dart';

List<String> titles = <String>['Grupos', 'Amigos', 'Locais', 'Missões'];

class GeralScreen extends StatelessWidget {
  const GeralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    const int tabsCount = 4;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AppBar Sample'),
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
        bottomNavigationBar: Container(
          color: Theme.of(context)
              .colorScheme
              .surface, // Cor padrão do modo escuro
          child: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.cloud_outlined),
                text: titles[0],
              ),
              Tab(
                icon: const Icon(Icons.beach_access_sharp),
                text: titles[1],
              ),
              Tab(
                icon: const Icon(Icons.brightness_5_sharp),
                text: titles[2],
              ),
              Tab(
                icon: const Icon(Icons.brightness_5_sharp),
                text: titles[3],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
