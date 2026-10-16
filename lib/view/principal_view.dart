import 'package:flutter/material.dart';

import 'nutricao_view.dart';
import 'treinos_view.dart';

//
// [VÍDEO] NAVEGAÇÃO · TELA PRINCIPAL
// Barra inferior (NavigationBar) com as duas áreas do tema: Treinos e Nutrição.
// Perfil, Exercícios, Tabela de alimentos, Sobre e Sair ficam no menu lateral (avatar no topo).
//
class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  int aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantém o estado (rolagem) de cada aba ao trocar.
      body: IndexedStack(
        index: aba,
        children: const [
          TreinosView(),
          NutricaoView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: aba,
        onDestinationSelected: (i) => setState(() => aba = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Nutrição',
          ),
        ],
      ),
    );
  }
}
