import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/alimento.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import 'grafico_macros.dart';

//
// QUANTIDADE DO ALIMENTO: pede os gramas e mostra a prévia da porção.
// Retorna os gramas, ou null se cancelar.
//
Future<double?> pedirQuantidade(
  BuildContext context,
  Alimento alimento, {
  double inicial = 100,
  String confirmar = 'Adicionar',
}) {
  return showDialog<double>(
    context: context,
    builder: (_) => _DialogoQuantidade(alimento: alimento, inicial: inicial, confirmar: confirmar),
  );
}

class _DialogoQuantidade extends StatefulWidget {
  const _DialogoQuantidade({required this.alimento, required this.inicial, required this.confirmar});

  final Alimento alimento;
  final double inicial;
  final String confirmar;

  @override
  State<_DialogoQuantidade> createState() => _DialogoQuantidadeState();
}

class _DialogoQuantidadeState extends State<_DialogoQuantidade> {
  late final txtGramas = TextEditingController(text: Formatos.numero(widget.inicial));

  @override
  void dispose() {
    txtGramas.dispose();
    super.dispose();
  }

  double? get gramas {
    final valor = double.tryParse(txtGramas.text.replaceAll(',', '.'));
    return (valor == null || valor <= 0 || valor > 5000) ? null : valor;
  }

  @override
  Widget build(BuildContext context) {
    final porcao = widget.alimento.porcao(gramas ?? 0);

    return AlertDialog(
      title: Text(widget.alimento.nome, style: const TextStyle(fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // INPUT GRAMAS
          TextField(
            controller: txtGramas,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(
              labelText: 'Quantidade',
              suffixText: 'g',
              errorText: gramas == null ? 'Informe de 1 a 5000 g.' : null,
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (gramas != null) Navigator.pop(context, gramas);
            },
          ),
          const SizedBox(height: 16),

          // PRÉVIA DA PORÇÃO
          Row(
            children: [
              const Expanded(
                child: Text('NESTA PORÇÃO', style: TextStyle(color: CronaColors.steel, fontSize: 11, letterSpacing: 1)),
              ),
              Text(
                Formatos.kcal(porcao.kcal),
                style: CronaTheme.mono(size: 15, weight: FontWeight.w700, color: CronaColors.collar),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GraficoMacros(macros: porcao, compacto: true),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: CronaColors.steel)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: gramas == null ? null : () => Navigator.pop(context, gramas),
          child: Text(widget.confirmar),
        ),
      ],
    );
  }
}
