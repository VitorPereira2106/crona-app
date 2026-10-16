import 'package:flutter/material.dart';

import '../model/alimento.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';

//
// [VÍDEO] RF006 · GRÁFICO COMPOSTO DE MACRONUTRIENTES (com percentual)
// 1) Faixa empilhada 100%: quanto cada macro representa da energia (percentual).
// 2) No modo completo, uma barra por macro com os gramas.
// Cores: proteína lilás, carboidrato roxo, gordura preta (com contorno).
//
Color corDoMacro(Macro m) {
  if (m == Macro.proteina) return CronaColors.proteina;
  if (m == Macro.carboidrato) return CronaColors.carboidrato;
  return CronaColors.gordura;
}

// O preto some no fundo escuro: ganha um contorno lilás.
BoxBorder? contorno(Macro m) {
  if (m == Macro.gordura) {
    return Border.all(color: CronaColors.lilac.withValues(alpha: 0.35));
  }
  return null;
}

class GraficoMacros extends StatelessWidget {
  const GraficoMacros({super.key, required this.macros, this.compacto = false});

  final Macros macros;

  // Compacto (cards): faixa + percentual de cada macro. Completo: faixa + barras em gramas.
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final percentuais = macros.percentuais();
    final descricao = [
      for (final m in Macro.values)
        '${m.rotulo} ${Formatos.gramas(macros.gramas(m))}, ${percentuais[m.index]} por cento',
    ].join('; ');

    return Semantics(
      label: 'Macronutrientes: $descricao',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FaixaComposicao(percentuais: percentuais, altura: compacto ? 10 : 14),
          SizedBox(height: compacto ? 8 : 14),
          if (compacto)
            Row(
              children: [
                for (final m in Macro.values)
                  Expanded(child: _LegendaCompacta(macro: m, percentual: percentuais[m.index])),
              ],
            )
          else
            for (final m in Macro.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _BarraGramas(macro: m, macros: macros, percentual: percentuais[m.index]),
              ),
        ],
      ),
    );
  }
}

//
// FAIXA 100%: cada macro ocupa a largura do seu percentual
//
class _FaixaComposicao extends StatelessWidget {
  const _FaixaComposicao({required this.percentuais, required this.altura});

  final List<int> percentuais;
  final double altura;

  @override
  Widget build(BuildContext context) {
    // Só os macros que aparecem (mais de 0%).
    final presentes = <Macro>[];
    for (final m in Macro.values) {
      if (percentuais[m.index] > 0) presentes.add(m);
    }
    // Sem alimentos: só o trilho vazio.
    if (presentes.isEmpty) {
      return Container(
        height: altura,
        decoration: BoxDecoration(
          color: CronaColors.robeRaised,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return SizedBox(
      height: altura,
      child: Row(
        children: [
          for (var i = 0; i < presentes.length; i++)
            Expanded(
              flex: percentuais[presentes[i].index],
              child: Container(
                margin: EdgeInsets.only(left: i == 0 ? 0 : 2), // respiro entre as partes
                decoration: BoxDecoration(
                  color: corDoMacro(presentes[i]),
                  border: contorno(presentes[i]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Amostra extends StatelessWidget {
  const _Amostra({required this.macro});

  final Macro macro;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: corDoMacro(macro),
        border: contorno(macro),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// Legenda dos cards: amostra, nome curto e percentual.
class _LegendaCompacta extends StatelessWidget {
  const _LegendaCompacta({required this.macro, required this.percentual});

  final Macro macro;
  final int percentual;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Amostra(macro: macro),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            macro.rotulo,
            style: const TextStyle(fontSize: 11, color: CronaColors.steel),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$percentual%',
          style: CronaTheme.mono(size: 12, weight: FontWeight.w700, color: CronaColors.collar),
        ),
      ],
    );
  }
}

class _BarraGramas extends StatelessWidget {
  const _BarraGramas({required this.macro, required this.macros, required this.percentual});

  final Macro macro;
  final Macros macros;
  final int percentual;

  @override
  Widget build(BuildContext context) {
    // A barra do macro com mais gramas fica cheia; as outras, proporcionais.
    var maior = 0.0;
    for (final m in Macro.values) {
      if (macros.gramas(m) > maior) maior = macros.gramas(m);
    }
    var valor = 0.0;
    if (maior > 0) valor = macros.gramas(macro) / maior;

    return Row(
      children: [
        _Amostra(macro: macro),
        const SizedBox(width: 6),
        SizedBox(
          width: 84,
          child: Text(macro.rotulo, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: CronaColors.robeRaised,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: valor,
              child: Container(
                decoration: BoxDecoration(
                  color: corDoMacro(macro),
                  border: contorno(macro),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 64,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              Formatos.gramas(macros.gramas(macro)),
              style: CronaTheme.mono(size: 13, color: CronaColors.steel),
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$percentual%',
            textAlign: TextAlign.right,
            style: CronaTheme.mono(size: 13, weight: FontWeight.w700, color: CronaColors.collar),
          ),
        ),
      ],
    );
  }
}
