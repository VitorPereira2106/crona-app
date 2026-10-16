import 'musculo.dart';

class Exercicio {
  const Exercicio({
    required this.id,
    required this.nome,
    required this.grupo,
    required this.equipamento,
    required this.padrao,
    required this.ativacao,
    required this.frequencia,
    required this.porQueFunciona,
    required this.execucao,
  });

  final String id;
  final String nome;

  // Grupo muscular usado na estatística de frequência (ex.: "peito").
  final String grupo;
  final String equipamento;
  final String padrao;

  // Ativação estimada de cada músculo, 0–100.
  final Map<Musculo, int> ativacao;

  // % das rotinas do grupo que usam o exercício (valor de referência).
  final int frequencia;
  final String porQueFunciona;
  final String execucao;

  // Músculo mais trabalhado pelo exercício.
  Musculo get primario {
    return musculosOrdenados.first.key;
  }

  // Músculos ordenados da maior para a menor ativação.
  List<MapEntry<Musculo, int>> get musculosOrdenados {
    final lista = ativacao.entries.toList();
    lista.sort((a, b) => b.value.compareTo(a.value));
    return lista;
  }
}
