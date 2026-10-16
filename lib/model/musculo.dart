//
// LISTA FIXA DE MÚSCULOS
//
enum Musculo {
  peitoral('Peitoral'),
  ombros('Deltoides'),
  biceps('Bíceps'),
  triceps('Tríceps'),
  antebraco('Antebraço'),
  abdomen('Abdômen'),
  obliquos('Oblíquos'),
  trapezio('Trapézio'),
  dorsal('Dorsal'),
  lombar('Lombar'),
  gluteos('Glúteos'),
  quadriceps('Quadríceps'),
  posteriores('Posteriores da coxa'),
  adutores('Adutores'),
  panturrilha('Panturrilha');

  const Musculo(this.nome);

  final String nome;
}
