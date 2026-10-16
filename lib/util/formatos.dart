//
// FORMATAÇÃO DE HORÁRIOS, DIAS E NÚMEROS
// Horários são guardados em minutos desde 00:00; dias seguem DateTime.weekday (1 = segunda).
//
class Formatos {
  static const diasCurtos = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  static String hora(int minutos) {
    final h = (minutos ~/ 60) % 24;
    final m = minutos % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static String intervalo(int inicio, int fim) => '${hora(inicio)} – ${hora(fim)}';

  static String diaCurto(int dia) => diasCurtos[dia - 1];

  static String dias(Iterable<int> dias) {
    final ordenados = dias.toList()..sort();
    return ordenados.map(diaCurto).join(' · ');
  }

  // ["a", "b", "c"] → "a, b e c"
  static String lista(List<String> itens) {
    if (itens.length <= 1) return itens.join();
    return '${itens.sublist(0, itens.length - 1).join(', ')} e ${itens.last}';
  }

  //
  // NÚMEROS (vírgula decimal, sem ",0" sobrando)
  //
  static String numero(double valor, {int casas = 1}) {
    final texto = valor.toStringAsFixed(casas).replaceAll('.', ',');
    return texto.contains(',') ? texto.replaceFirst(RegExp(r',?0+$'), '') : texto;
  }

  static String gramas(double valor) => '${numero(valor)} g';

  static String kcal(double valor) => '${valor.round()} kcal';

  // "Feijão" → "feijao": busca sem depender de acento.
  static String semAcento(String texto) {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const para = 'aaaaaeeeeiiiiooooouuuucn';
    final buffer = StringBuffer();
    for (final ch in texto.toLowerCase().split('')) {
      final i = de.indexOf(ch);
      buffer.write(i == -1 ? ch : para[i]);
    }
    return buffer.toString();
  }
}
