import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:pi_app/app/views/amigos_screen.dart';
import 'package:pi_app/app/views/grupos_screen.dart';
=======
import 'package:pi_app/app/views/local_screen.dart';
>>>>>>> othavio

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
<<<<<<< HEAD
<<<<<<< HEAD
          title: const Text('Nome do App'), // Editar nome do app
=======
          title: const Text(
            'SportSync',
            style: TextStyle(
              fontFamily: 'RussoOne',
            ),
          ),
>>>>>>> Diogo
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Colocar a imagem do usuário integrado com backend
              ),
              onPressed: () {},
            ),
          ],
=======
          title: const Text('AppBar Sample'),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
>>>>>>> othavio
        ),
        body: const TabBarView(
          children: <Widget>[
<<<<<<< HEAD
            GruposScreen(),
            AmigosScreen(),
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
                  offset: const Offset(0, 3),
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
=======
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
>>>>>>> othavio
          ),
        ),
      ),
    );
  }
}
