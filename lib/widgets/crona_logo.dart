import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import 'zigue_zague.dart';

//
// LOGO: C-relógio (gola da Crona) com a Ragnarok como ponteiro dos minutos.
// Desenho próprio do logo (C-relógio com a espada como ponteiro).
//
class CronaLogo extends StatelessWidget {
  const CronaLogo({super.key, this.tamanho = 48, this.comFundo = false});

  final double tamanho;
  final bool comFundo;

  static const _svg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <path d="M142.4 57.6 A60 60 0 1 0 142.4 142.4" fill="none" stroke="#CDB6D6" stroke-width="30"/>
  <g fill="#1B1A33"><circle cx="40" cy="78" r="5"/><circle cx="40" cy="100" r="5"/><circle cx="40" cy="122" r="5"/></g>
  <g stroke="#8C8A99" stroke-width="3" stroke-linecap="round"><line x1="100" y1="60" x2="100" y2="67"/><line x1="100" y1="133" x2="100" y2="140"/></g>
  <line x1="100" y1="100" x2="80.9" y2="89" stroke="#F5F2F7" stroke-width="6" stroke-linecap="round"/>
  <line x1="96.24" y1="101.37" x2="109.4" y2="96.58" stroke="#F5F2F7" stroke-width="5" stroke-linecap="round"/>
  <polygon points="109.4,96.58 116.32,106.83 116.92,93.84 108.12,84.27" fill="#B98AAE"/>
  <polygon points="118.63,98.54 167.68,75.38 115.21,89.14" fill="#121117" stroke="#F5F2F7" stroke-width="2.5" stroke-linejoin="round"/>
  <circle cx="100" cy="100" r="6" fill="#B98AAE"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    final logo = SvgPicture.string(
      _svg,
      width: tamanho,
      height: tamanho,
      semanticsLabel: 'Logotipo do Crona',
    );
    if (!comFundo) return logo;

    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        color: CronaColors.night,
        borderRadius: BorderRadius.circular(tamanho * 0.28),
        border: Border.all(color: CronaColors.robeRaised),
      ),
      child: Padding(padding: EdgeInsets.all(tamanho * 0.08), child: logo),
    );
  }
}

//
// LOGO + NOME (lockup)
//
class CronaMarca extends StatelessWidget {
  const CronaMarca({super.key, this.tamanho = 72});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    // Encolhe em telas estreitas em vez de transbordar.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: lockup(),
    );
  }

  Widget lockup() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CronaLogo(tamanho: tamanho),
        SizedBox(width: tamanho * 0.15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'crona',
              style: CronaTheme.display(size: tamanho * 0.72, color: CronaColors.lilac),
            ),
            ZigueZague(largura: tamanho * 1.6),
          ],
        ),
      ],
    );
  }
}
