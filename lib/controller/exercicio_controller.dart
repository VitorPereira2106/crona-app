import 'package:flutter/material.dart';

import '../data/exercicios_mock.dart';
import '../model/exercicio.dart';
import '../model/musculo.dart';
import '../util/formatos.dart';

class ExercicioController extends ChangeNotifier {
  final List<Exercicio> todos = exerciciosMock;

  String busca = '';
  Musculo? filtroMusculo;

  Exercicio porId(String id) {
    return todos.firstWhere((e) => e.id == id);
  }

  // Músculos que são o principal de algum exercício (viram os chips de filtro).
  List<Musculo> get musculosComExercicio {
    final lista = <Musculo>[];
    for (final musculo in Musculo.values) {
      for (final e in todos) {
        if (e.primario == musculo) {
          lista.add(musculo);
          break;
        }
      }
    }
    return lista;
  }

  // Exercícios que passam na busca (nome ou equipamento) e no filtro de músculo.
  List<Exercicio> get filtrados {
    final termo = Formatos.semAcento(busca.trim());
    final lista = <Exercicio>[];

    for (final e in todos) {
      final nome = Formatos.semAcento(e.nome);
      final equipamento = Formatos.semAcento(e.equipamento);
      final passaBusca = termo.isEmpty || nome.contains(termo) || equipamento.contains(termo);
      final passaMusculo = filtroMusculo == null || e.ativacao.containsKey(filtroMusculo);

      if (passaBusca && passaMusculo) lista.add(e);
    }
    return lista;
  }

  void buscar(String termo) {
    busca = termo;
    notifyListeners();
  }

  void filtrar(Musculo? musculo) {
    filtroMusculo = musculo;
    notifyListeners();
  }
}
