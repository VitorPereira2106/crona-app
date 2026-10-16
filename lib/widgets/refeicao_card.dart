import 'package:flutter/material.dart';

import '../model/refeicao.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import 'grafico_macros.dart';

//
// CARD DE REFEIÇÃO: horário, nome, kcal e o gráfico de macros com percentual.
//
class RefeicaoCard extends StatelessWidget {
  const RefeicaoCard({super.key, required this.refeicao, this.onTap, this.percentualDoDia});

  final Refeicao refeicao;
  final VoidCallback? onTap;

  // Quanto esta refeição representa das calorias do dia.
  final int? percentualDoDia;

  @override
  Widget build(BuildContext context) {
    final macros = refeicao.macros;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: CronaColors.mauve.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.restaurant, size: 20, color: CronaColors.mauve),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formatos.intervalo(refeicao.inicio, refeicao.fim),
                          style: CronaTheme.mono(size: 12, color: CronaColors.steel),
                        ),
                        Text(
                          refeicao.nome,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${macros.kcal.round()}',
                        style: CronaTheme.mono(size: 18, weight: FontWeight.w700, color: CronaColors.collar),
                      ),
                      Text(
                        percentualDoDia == null ? 'kcal' : 'kcal · $percentualDoDia% do dia',
                        style: const TextStyle(fontSize: 11, color: CronaColors.steel),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GraficoMacros(macros: macros, compacto: true),
            ],
          ),
        ),
      ),
    );
  }
}
