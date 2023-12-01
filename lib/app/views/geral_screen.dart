import 'package:flutter/material.dart';
import 'package:pi_app/app/views/amigos_screen.dart';
import 'package:pi_app/app/views/grupos_screen.dart';
import 'package:pi_app/app/views/local_screen.dart';
import 'package:pi_app/app/views/minha_conta_screen.dart';
import 'package:pi_app/app/views/missoes_greal_screen.dart';

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
          title: const Text(
            'SportSync',
            style: TextStyle(
              fontFamily: 'RussoOne',
            ),
          ),
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Colocar a imagem do usuário integrado com backend
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MinhaContaScreen()),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[
            GruposScreen(),
            AmigosScreen(),
            LocalScreen(),
            MissoesGeralScreen()
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
                  icon: const Icon(Icons.star),
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
