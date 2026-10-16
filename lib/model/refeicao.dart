import 'alimento.dart';

//
// ITEM DA REFEIÇÃO: um alimento da TACO e a quantidade em gramas
//
class ItemRefeicao {
  ItemRefeicao({required this.alimento, required this.gramas});

  final Alimento alimento;
  double gramas;

  Macros get macros => alimento.porcao(gramas);

  ItemRefeicao copia() => ItemRefeicao(alimento: alimento, gramas: gramas);
}

//
// REFEIÇÃO (café da manhã, almoço...) com horário e alimentos
//
class Refeicao {
  Refeicao({
    required this.id,
    required this.nome,
    required this.inicio,
    required this.fim,
    List<ItemRefeicao>? itens,
  }) : itens = itens ?? [];

  final String id;
  String nome;
  int inicio; // minutos desde 00:00
  int fim;
  final List<ItemRefeicao> itens;

  Macros get macros {
    var total = const Macros();
    for (final item in itens) {
      total = total.somar(item.macros);
    }
    return total;
  }

  Refeicao copia() => Refeicao(
        id: id,
        nome: nome,
        inicio: inicio,
        fim: fim,
        itens: itens.map((i) => i.copia()).toList(),
      );
}

//
// CARDÁPIO: o dia cheio, salvo como grupo e aplicado aos dias da semana
// (ex.: "Segunda", "Terça a sexta"). Cada dia tem no máximo um cardápio.
//
class Cardapio {
  Cardapio({
    required this.id,
    required this.nome,
    required this.dias,
    List<Refeicao>? refeicoes,
  }) : refeicoes = refeicoes ?? [];

  final String id;
  String nome;
  Set<int> dias; // DateTime.weekday
  final List<Refeicao> refeicoes;

  Macros get macros {
    var total = const Macros();
    for (final r in refeicoes) {
      total = total.somar(r.macros);
    }
    return total;
  }

  // Quanto cada refeição representa das calorias do dia (%).
  List<int> percentualPorRefeicao() {
    final kcal = <double>[];
    for (final r in refeicoes) {
      kcal.add(r.macros.kcal);
    }
    return repartir(kcal);
  }

  void ordenar() => refeicoes.sort((a, b) => a.inicio.compareTo(b.inicio));

  Cardapio copia() => Cardapio(
        id: id,
        nome: nome,
        dias: Set.of(dias),
        refeicoes: refeicoes.map((r) => r.copia()).toList(),
      );
}
