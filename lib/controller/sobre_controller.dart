import 'package:flutter/material.dart';

// [VÍDEO] RF004 · SOBRE: objetivo do app, integrantes, disciplina, instituição, professor e versão.
class SobreController extends ChangeNotifier {
  final objetivo =
      'Organiza treino e alimentação: monte seus treinos e veja o percentual de '
      'cada músculo; monte suas refeições com a Tabela TACO e veja o percentual '
      'de proteína, carboidrato e gordura.';

  final integrantes = const [
    'Luis Henrique Paziani',
    'João Vitor Pereira Delaspora',
  ];

  final disciplina = 'Programação para Dispositivos Móveis';
  final instituicao = 'Fatec Ribeirão Preto';
  final professor = 'Rodrigo Plotze';
  final versao = '0.1.0 · Parte 1';
}
