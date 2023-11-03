import 'package:flutter/material.dart';
import 'package:pi_app/app/views/local_screen.dart';

List<String> titles = <String>['Grupos', 'Amigos', 'Locais', 'Missões'];

class GeralScreen extends StatelessWidget {
  const GeralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 4;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AppBar Sample'),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
        ),
        body: const TabBarView(
          children: <Widget>[
            LocalScreen()
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
