import 'package:flutter/material.dart';

import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';

//
// COMPONENTE-ASSINATURA: barra horizontal malva com nome e percentual.
//
class LinhaAtivacao extends StatelessWidget {
  const LinhaAtivacao({
    super.key,
    required this.rotulo,
    required this.percentual,
    this.compacta = false,
  });

  final String rotulo;
  final int percentual;
  final bool compacta;

  @override
  Widget build(BuildContext context) {
    final barra = ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: percentual / 100,
        minHeight: compacta ? 6 : 8,
        color: CronaColors.mauve,
        backgroundColor: CronaColors.robeRaised,
      ),
    );
    final valor = Text(
      '$percentual%',
      style: CronaTheme.mono(color: CronaColors.mauve, weight: FontWeight.w700),
    );

    return Semantics(
      label: '$rotulo, $percentual por cento',
      excludeSemantics: true,
      child: compacta
          ? Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(rotulo, style: const TextStyle(fontSize: 12)),
                ),
                Expanded(child: barra),
                const SizedBox(width: 8),
                SizedBox(width: 40, child: Align(alignment: Alignment.centerRight, child: valor)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rotulo,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    valor,
                  ],
                ),
                const SizedBox(height: 4),
                barra,
              ],
            ),
    );
  }
}
