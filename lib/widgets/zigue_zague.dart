import 'package:flutter/material.dart';

import '../theme/crona_colors.dart';

//
// "LINHA DA LOUCURA": sublinhado em zigue-zague, só em títulos importantes.
//
class ZigueZague extends StatelessWidget {
  const ZigueZague({
    super.key,
    this.largura = 120,
    this.cor = CronaColors.mauve,
  });

  final double largura;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(largura, 10),
      painter: _ZigueZaguePainter(cor),
    );
  }
}

class _ZigueZaguePainter extends CustomPainter {
  _ZigueZaguePainter(this.cor);

  final Color cor;

  @override
  void paint(Canvas canvas, Size size) {
    const passo = 9.0;
    final path = Path()..moveTo(0, size.height - 2);
    var x = 0.0;
    var alto = true;
    while (x < size.width) {
      x += passo;
      path.lineTo(x.clamp(0, size.width), alto ? 2 : size.height - 2);
      alto = !alto;
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = cor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_ZigueZaguePainter oldDelegate) => oldDelegate.cor != cor;
}
