import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/musculo.dart';
import '../model/treino.dart';
import '../util/formatos.dart';
import 'exercicio_controller.dart';

class TreinoController extends ChangeNotifier {
  final exercicios = GetIt.I<ExercicioController>();

  // ROTINA INICIAL (dados estáticos da Parte 1)
  final List<Treino> treinos = [
    Treino(
      id: 'a',
      nome: 'Treino A · Push',
      dias: {1, 4},
      inicio: 17 * 60 + 30,
      duracao: 75,
      itens: [
        ItemTreino(exercicioId: 'supino_reto', series: 4, repeticoes: '8–10', descanso: 90),
        ItemTreino(exercicioId: 'supino_inclinado', series: 3, repeticoes: '10–12', descanso: 75),
        ItemTreino(exercicioId: 'desenvolvimento', series: 3, repeticoes: '8–10', descanso: 90),
        ItemTreino(exercicioId: 'elevacao_lateral', series: 3, repeticoes: '12–15', descanso: 60),
        ItemTreino(exercicioId: 'triceps_polia', series: 3, repeticoes: '12', descanso: 60),
      ],
    ),
    Treino(
      id: 'b',
      nome: 'Treino B · Pull',
      dias: {2, 5},
      inicio: 7 * 60,
      duracao: 60,
      itens: [
        ItemTreino(exercicioId: 'puxada_frente', series: 4, repeticoes: '10', descanso: 75),
        ItemTreino(exercicioId: 'remada_curvada', series: 4, repeticoes: '8–10', descanso: 90),
        ItemTreino(exercicioId: 'rosca_direta', series: 3, repeticoes: '10–12', descanso: 60),
        ItemTreino(exercicioId: 'rosca_martelo', series: 3, repeticoes: '12', descanso: 60),
      ],
    ),
    Treino(
      id: 'c',
      nome: 'Treino C · Pernas',
      dias: {3, 6},
      inicio: 17 * 60 + 15,
      duracao: 75,
      itens: [
        ItemTreino(exercicioId: 'agachamento', series: 4, repeticoes: '8', descanso: 120),
        ItemTreino(exercicioId: 'leg_press', series: 3, repeticoes: '12', descanso: 90),
        ItemTreino(exercicioId: 'stiff', series: 3, repeticoes: '10', descanso: 90),
        ItemTreino(exercicioId: 'cadeira_extensora', series: 3, repeticoes: '12–15', descanso: 60),
        ItemTreino(exercicioId: 'panturrilha_pe', series: 4, repeticoes: '15', descanso: 45),
        ItemTreino(exercicioId: 'prancha', series: 3, repeticoes: '45 s', descanso: 45),
      ],
    ),
  ];

  int proximoId = 1;

  Treino porId(String id) {
    return treinos.firstWhere((t) => t.id == id);
  }

  Treino? buscar(String id) {
    for (final treino in treinos) {
      if (treino.id == id) return treino;
    }
    return null;
  }

  Treino novo() {
    proximoId++;
    return Treino(
      id: 'novo-$proximoId',
      nome: '',
      dias: {},
      inicio: 18 * 60,
      duracao: 60,
      itens: [],
    );
  }

  //
  // [VÍDEO] RF006 · CONFLITO DE HORÁRIO ENTRE TREINOS
  // Dois treinos no mesmo dia se chocam quando um começa antes do outro terminar.
  // Ex.: 17:30–18:45 e 18:00–18:30 batem; 06:00–07:00 e 07:00–08:00 não.
  //
  List<String> conflitos(Treino treino) {
    final dias = treino.dias.toList();
    dias.sort();

    final lista = <String>[];
    for (final dia in dias) {
      for (final outro in treinos) {
        if (outro.id == treino.id) continue; // ele mesmo (quando está editando)
        if (!outro.dias.contains(dia)) continue;

        final bate = treino.inicio < outro.fim && outro.inicio < treino.fim;
        if (bate) {
          final horario = Formatos.intervalo(outro.inicio, outro.fim);
          lista.add('${Formatos.diaCurto(dia)} · ${outro.nome} ($horario)');
        }
      }
    }
    return lista;
  }

  // [VÍDEO] GERENCIAMENTO DE ESTADO · notifyListeners() avisa as telas que a lista mudou.
  void salvar(Treino treino) {
    final i = treinos.indexWhere((t) => t.id == treino.id);
    if (i == -1) {
      treinos.add(treino);
    } else {
      treinos[i] = treino;
    }
    notifyListeners();
  }

  // Retorna a posição, para o "Desfazer".
  int remover(Treino treino) {
    final i = treinos.indexOf(treino);
    treinos.removeAt(i);
    notifyListeners();
    return i;
  }

  void restaurar(Treino treino, int posicao) {
    treinos.insert(posicao, treino);
    notifyListeners();
  }

  //
  // [VÍDEO] RF006 · PERCENTUAL DE ATIVAÇÃO MUSCULAR DO TREINO
  // 1) Soma, para cada músculo, a ativação do exercício × número de séries.
  // 2) O músculo com a maior soma vira 100% e os outros ficam proporcionais.
  // 3) Músculos com menos de 10% não aparecem.
  //
  Map<Musculo, int> ativacao(Treino treino) {
    final soma = <Musculo, int>{};
    for (final item in treino.itens) {
      final exercicio = exercicios.porId(item.exercicioId);
      for (final musculo in exercicio.ativacao.keys) {
        final valor = exercicio.ativacao[musculo]! * item.series;
        soma[musculo] = (soma[musculo] ?? 0) + valor;
      }
    }

    var maior = 0;
    for (final valor in soma.values) {
      if (valor > maior) maior = valor;
    }

    final resultado = <Musculo, int>{};
    for (final musculo in soma.keys) {
      final percentual = (soma[musculo]! * 100 / maior).round();
      if (percentual >= 10) resultado[musculo] = percentual;
    }
    return resultado;
  }

  // Os 3 músculos mais trabalhados (etiquetas da lista de treinos).
  List<Musculo> foco(Treino treino) {
    final lista = ativacao(treino).entries.toList();
    lista.sort((a, b) => b.value.compareTo(a.value));

    final musculos = <Musculo>[];
    for (final e in lista.take(3)) {
      musculos.add(e.key);
    }
    return musculos;
  }
}
