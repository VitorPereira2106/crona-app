//
// PRESCRIÇÃO: um exercício dentro de um treino 
//
class ItemTreino {
  ItemTreino({
    required this.exercicioId,
    this.series = 3,
    this.repeticoes = '10–12',
    this.descanso = 60,
  });

  final String exercicioId;
  int series;
  String repeticoes;
  int descanso; // segundos

  ItemTreino copia() => ItemTreino(
        exercicioId: exercicioId,
        series: series,
        repeticoes: repeticoes,
        descanso: descanso,
      );
}

class Treino {
  Treino({
    required this.id,
    required this.nome,
    required this.dias,
    required this.inicio,
    required this.duracao,
    required this.itens,
  });

  final String id;
  String nome;
  Set<int> dias; // DateTime.weekday: 1 = segunda ... 7 = domingo
  int inicio; // minutos desde 00:00
  int duracao; // minutos
  List<ItemTreino> itens;

  int get fim => inicio + duracao;

  Treino copia() => Treino(
        id: id,
        nome: nome,
        dias: Set.of(dias),
        inicio: inicio,
        duracao: duracao,
        itens: itens.map((i) => i.copia()).toList(),
      );

  // Duração sugerida: séries × (40 s + descanso) + 10 min de aquecimento.
  static int duracaoSugerida(List<ItemTreino> itens) {
    var segundos = 0;
    for (final item in itens) {
      segundos += item.series * (40 + item.descanso);
    }
    return (segundos / 60).ceil() + 10;
  }
}
