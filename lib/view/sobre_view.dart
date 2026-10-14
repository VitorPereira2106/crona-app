import 'package:flutter/material.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Sobre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                """Crona é um aplicativo de gerenciar cronogramas desenvolvido por Luis Henrique Paziani e João Vitor Pereira Delaspora como um trabalho de faculdade.
                \nDisciplina: Programação Para Dispositivos Móveis
                \nInstituição: Fatec Ribeirão Preto
                \nProfessor: Rodrigo Plotze
              """,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
