//
// TIPOS DE ALIMENTO (filtro da tabela de alimentos)
//
enum GrupoAlimento {
  cereais('Cereais'),
  verduras('Verduras e legumes'),
  frutas('Frutas'),
  carnes('Carnes, peixes e ovos'),
  leite('Leite e derivados'),
  feijoes('Feijões'),
  outros('Outros');

  const GrupoAlimento(this.rotulo);

  final String rotulo;
}

//
// ALIMENTO DA TACO: valores por 100 g de parte comestível
//
class Alimento {
  const Alimento(
    this.id,
    this.nome,
    this.grupo,
    this.kcal,
    this.proteina,
    this.carboidrato,
    this.lipidio,
    this.fibra,
  );

  final int id;
  final String nome;
  final GrupoAlimento grupo;
  final double kcal;
  final double proteina; // g
  final double carboidrato; // g
  final double lipidio; // g (gordura)
  final double fibra; // g

  // Valores para uma porção (os da tabela são para 100 g).
  Macros porcao(double gramas) {
    final fator = gramas / 100;
    return Macros(
      kcal: kcal * fator,
      proteina: proteina * fator,
      carboidrato: carboidrato * fator,
      lipidio: lipidio * fator,
    );
  }
}

//
// MACRONUTRIENTES (sempre nesta ordem: proteína, carboidrato, gordura)
//
enum Macro {
  proteina('Proteína', 4),
  carboidrato('Carboidrato', 4),
  gordura('Gordura', 9);

  const Macro(this.rotulo, this.kcalPorGrama);

  final String rotulo;
  final int kcalPorGrama; // 1 g de proteína ou carboidrato = 4 kcal; 1 g de gordura = 9 kcal
}

// Totais de uma porção, refeição ou dia.
class Macros {
  const Macros({
    this.kcal = 0,
    this.proteina = 0,
    this.carboidrato = 0,
    this.lipidio = 0,
  });

  final double kcal;
  final double proteina;
  final double carboidrato;
  final double lipidio;

  Macros somar(Macros outro) {
    return Macros(
      kcal: kcal + outro.kcal,
      proteina: proteina + outro.proteina,
      carboidrato: carboidrato + outro.carboidrato,
      lipidio: lipidio + outro.lipidio,
    );
  }

  double gramas(Macro m) {
    if (m == Macro.proteina) return proteina;
    if (m == Macro.carboidrato) return carboidrato;
    return lipidio;
  }

  //
  // [VÍDEO] RF006 · PERCENTUAL DE CADA MACRO NA ENERGIA DA REFEIÇÃO
  // Ex.: 48 g de proteína = 192 kcal e 3,75 g de gordura = 33,75 kcal → 85% e 15%.
  //
  List<int> percentuais() {
    final energia = <double>[];
    for (final m in Macro.values) {
      energia.add(gramas(m) * m.kcalPorGrama);
    }
    return repartir(energia);
  }
}

//
// Divide 100% entre os valores. Arredonda cada um e, se a soma não der 100,
// acerta a diferença no maior valor. Ex.: [1, 1, 1] → [34, 33, 33].
//
List<int> repartir(List<double> valores) {
  var total = 0.0;
  for (final v in valores) {
    total += v;
  }

  final resultado = <int>[];
  if (total == 0) {
    for (var i = 0; i < valores.length; i++) {
      resultado.add(0);
    }
    return resultado;
  }

  var soma = 0;
  var maior = 0; // posição do maior valor
  for (var i = 0; i < valores.length; i++) {
    final p = (valores[i] * 100 / total).round();
    resultado.add(p);
    soma += p;
    if (valores[i] > valores[maior]) maior = i;
  }
  resultado[maior] += 100 - soma;
  return resultado;
}
