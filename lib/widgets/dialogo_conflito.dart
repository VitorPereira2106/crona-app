import 'package:flutter/material.dart';

import '../theme/crona_colors.dart';
import 'sangue_negro.dart';

//
// DIÁLOGO DE CONFLITO (voz da Crona)
// Retorna true para "Manter mesmo assim" e false para "Ajustar horário".
//
class DialogoConflito extends StatelessWidget {
  const DialogoConflito({super.key, required this.conflitos});

  final List<String> conflitos;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const GotaSangueNegro(tamanho: 40),
      title: const Text('Dois compromissos no mesmo horário?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eu não sei lidar com isso... Este horário bate com:',
            style: TextStyle(color: CronaColors.steel),
          ),
          const SizedBox(height: 12),
          for (final c in conflitos)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const GotaSangueNegro(tamanho: 12),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c)),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Manter mesmo assim', style: TextStyle(color: CronaColors.steel)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Ajustar horário'),
        ),
      ],
    );
  }
}

