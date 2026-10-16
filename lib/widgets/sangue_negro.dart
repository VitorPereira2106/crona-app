import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/crona_colors.dart';

//
// GOTA DE SANGUE NEGRO: ícone de conflito e erro.
// Gota preta com contorno lilás (para aparecer no fundo escuro).
//
class GotaSangueNegro extends StatelessWidget {
  const GotaSangueNegro({super.key, this.tamanho = 16});

  final double tamanho;

  static String _hex(Color cor) =>
      '#${(cor.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  static final _svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<path d="M12 2.5C12 2.5 19 11 19 15.5A7 7 0 0 1 5 15.5C5 11 12 2.5 12 2.5Z" '
      'fill="${_hex(CronaColors.blackBlood)}" stroke="${_hex(CronaColors.lilac)}" '
      'stroke-width="1.6" stroke-linejoin="round"/>'
      // brilho (como o sangue no anime)
      '<path d="M8.6 14.2c0-1.6 1-3.4 2-4.8" fill="none" stroke="${_hex(CronaColors.collar)}" '
      'stroke-width="1.5" stroke-linecap="round"/>'
      '</svg>';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Conflito',
      child: SvgPicture.string(_svg, width: tamanho, height: tamanho),
    );
  }
}
