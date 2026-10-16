//
// ALIMENTOS (dados estáticos da Parte 1)
// Valores da Tabela Brasileira de Composição de Alimentos (TACO), 4ª ed., NEPA/UNICAMP, 2011.
// Por 100 g: kcal, proteína, carboidrato, lipídio e fibra (g). O id é o número do alimento na TACO.
//
import '../model/alimento.dart';

const alimentosTaco = <Alimento>[
  // CEREAIS
  Alimento(3, 'Arroz, tipo 1, cozido', GrupoAlimento.cereais, 128, 2.5, 28.1, 0.2, 1.6),
  Alimento(53, 'Pão, trigo, francês', GrupoAlimento.cereais, 300, 8, 58.6, 3.1, 2.3),
  Alimento(52, 'Pão, trigo, forma, integral', GrupoAlimento.cereais, 253, 9.4, 49.9, 3.7, 6.9),
  Alimento(7, 'Aveia, flocos, crua', GrupoAlimento.cereais, 394, 13.9, 66.6, 8.5, 9.1),
  Alimento(533, 'Cuscuz, de milho, cozido com sal', GrupoAlimento.cereais, 113, 2.2, 25.3, 0.7, 2.1),

  // VERDURAS E LEGUMES
  Alimento(100, 'Brócolis, cozido', GrupoAlimento.verduras, 25, 2.1, 4.4, 0.5, 3.4),
  Alimento(88, 'Batata, doce, cozida', GrupoAlimento.verduras, 77, 0.6, 18.4, 0.1, 2.2),
  Alimento(78, 'Alface, crespa, crua', GrupoAlimento.verduras, 11, 1.3, 1.7, 0.2, 1.8),
  Alimento(157, 'Tomate, com semente, cru', GrupoAlimento.verduras, 15, 1.1, 3.1, 0.2, 1.2),
  Alimento(109, 'Cenoura, cozida', GrupoAlimento.verduras, 30, 0.8, 6.7, 0.2, 2.6),
  Alimento(129, 'Mandioca, cozida', GrupoAlimento.verduras, 125, 0.6, 30.1, 0.3, 1.6),

  // FRUTAS
  Alimento(182, 'Banana, prata, crua', GrupoAlimento.frutas, 98, 1.3, 26, 0.1, 2),
  Alimento(222, 'Maçã, Fuji, com casca, crua', GrupoAlimento.frutas, 56, 0.3, 15.2, 0, 1.3),
  Alimento(163, 'Abacate, cru', GrupoAlimento.frutas, 96, 1.2, 6, 8.4, 6.3),
  Alimento(225, 'Mamão, Formosa, cru', GrupoAlimento.frutas, 45, 0.8, 11.6, 0.1, 1.8),

  // CARNES, PEIXES E OVOS
  Alimento(410, 'Frango, peito, sem pele, grelhado', GrupoAlimento.carnes, 159, 32, 0, 2.5, 0),
  Alimento(377, 'Carne, bovina, patinho, sem gordura, grelhado', GrupoAlimento.carnes, 219, 35.9, 0, 7.3, 0),
  Alimento(326, 'Carne, bovina, acém, moído, cozido', GrupoAlimento.carnes, 212, 26.7, 0, 10.9, 0),
  Alimento(317, 'Salmão, sem pele, fresco, grelhado', GrupoAlimento.carnes, 243, 26.1, 0, 14.5, 0),
  Alimento(277, 'Atum, conserva em óleo', GrupoAlimento.carnes, 166, 26.2, 0, 6, 0),
  Alimento(488, 'Ovo, de galinha, inteiro, cozido/10minutos', GrupoAlimento.carnes, 146, 13.3, 0.6, 9.5, 0),

  // LEITE E DERIVADOS
  Alimento(461, 'Queijo, minas, frescal', GrupoAlimento.leite, 264, 17.4, 3.2, 20.2, 0),
  Alimento(448, 'Iogurte, natural', GrupoAlimento.leite, 51, 4.1, 1.9, 3, 0),
  Alimento(463, 'Queijo, mozarela', GrupoAlimento.leite, 330, 22.6, 3, 25.2, 0),

  // FEIJÕES
  Alimento(561, 'Feijão, carioca, cozido', GrupoAlimento.feijoes, 76, 4.8, 13.6, 0.5, 8.5),
  Alimento(567, 'Feijão, preto, cozido', GrupoAlimento.feijoes, 77, 4.5, 14, 0.5, 8.4),

  // OUTROS
  Alimento(260, 'Azeite, de oliva, extra virgem', GrupoAlimento.outros, 884, 0, 0, 100, 0),
  Alimento(471, 'Café, infusão 10%', GrupoAlimento.outros, 9, 0.7, 1.5, 0.1, 0),
  Alimento(507, 'Mel, de abelha', GrupoAlimento.outros, 309, 0, 84, 0, 0),
  Alimento(588, 'Castanha-de-caju, torrada, salgada', GrupoAlimento.outros, 570, 18.5, 29.1, 46.3, 3.7),
];
