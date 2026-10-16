import 'package:flutter/material.dart';

import '../theme/crona_colors.dart';
import 'crona_logo.dart';

//
// ESTADO VAZIO no tom da Crona: gentil, curto, sempre com uma ação.
//
class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.mensagem,
    this.acao,
    this.onAcao,
  });

  final String mensagem;
  final String? acao;
  final VoidCallback? onAcao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Opacity(opacity: 0.5, child: CronaLogo(tamanho: 56)),
          const SizedBox(height: 12),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CronaColors.steel, height: 1.4),
          ),
          if (acao != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onAcao,
              style: OutlinedButton.styleFrom(minimumSize: const Size(160, 44)),
              child: Text(acao!),
            ),
          ],
        ],
      ),
    );
  }
}
