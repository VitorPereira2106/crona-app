import 'package:flutter/material.dart';

import '../data/alimentos_taco.dart';
import '../model/alimento.dart';
import '../model/refeicao.dart';
import '../util/formatos.dart';

//
// NUTRIÇÃO: alimentos da TACO, refeições e cardápios do dia
//
class NutricaoController extends ChangeNotifier {
  NutricaoController() {
    cardapios.add(cardapioSegunda());
    cardapios.add(cardapioTercaASexta());
  }

  //
  // ALIMENTOS
  //
  final List<Alimento> alimentos = alimentosTaco;

  Alimento alimento(int id) {
    return alimentos.firstWhere((a) => a.id == id);
  }

  // Busca sem acento. Todas as palavras digitadas precisam estar no nome.
  // Ex.: "frango grelhado" acha "Frango, peito, sem pele, grelhado".
  List<Alimento> buscarAlimentos(String texto, GrupoAlimento? grupo) {
    final palavras = Formatos.semAcento(texto).split(' ');
    final resultado = <Alimento>[];

    for (final a in alimentos) {
      if (grupo != null && a.grupo != grupo) continue;

      final nome = Formatos.semAcento(a.nome);
      var achou = true;
      for (final p in palavras) {
        if (!nome.contains(p)) {
          achou = false;
          break;
        }
      }
      if (achou) resultado.add(a);
    }
    return resultado;
  }

  //
  // CARDÁPIOS
  //
  final List<Cardapio> cardapios = [];
  int proximoId = 1;

  String novoId(String prefixo) {
    proximoId++;
    return '$prefixo-$proximoId';
  }

  Cardapio? buscar(String id) {
    for (final c in cardapios) {
      if (c.id == id) return c;
    }
    return null;
  }

  // Cardápio usado em um dia da semana (1 = segunda).
  Cardapio? doDia(int dia) {
    for (final c in cardapios) {
      if (c.dias.contains(dia)) return c;
    }
    return null;
  }

  // Cardápio que está sendo montado. A tela do cardápio e a da refeição mexem nele
  // e só no "Salvar cardápio" ele vai para a lista.
  Cardapio? rascunho;

  // Retorna true quando está editando um cardápio que já existe.
  bool iniciarRascunho({String? id}) {
    Cardapio? existente;
    if (id != null) existente = buscar(id);

    if (existente != null) {
      rascunho = existente.copia();
      return true;
    }
    rascunho = Cardapio(id: novoId('cardapio'), nome: '', dias: {});
    return false;
  }

  // Refeição nova começa 3h depois da última (ou às 07:00 se for a primeira).
  Refeicao novaRefeicao() {
    var inicio = 7 * 60;
    if (rascunho!.refeicoes.isNotEmpty) {
      inicio = rascunho!.refeicoes.last.fim + 3 * 60;
      if (inicio > 23 * 60) inicio = 23 * 60;
    }
    return Refeicao(id: novoId('refeicao'), nome: '', inicio: inicio, fim: inicio + 30);
  }

  void salvarRefeicao(Refeicao refeicao) {
    final lista = rascunho!.refeicoes;
    final i = lista.indexWhere((r) => r.id == refeicao.id);
    if (i == -1) {
      lista.add(refeicao);
    } else {
      lista[i] = refeicao;
    }
    rascunho!.ordenar();
    notifyListeners();
  }

  // Retorna a posição, para o "Desfazer".
  int removerRefeicao(Refeicao refeicao) {
    final i = rascunho!.refeicoes.indexWhere((r) => r.id == refeicao.id);
    rascunho!.refeicoes.removeAt(i);
    notifyListeners();
    return i;
  }

  void restaurarRefeicao(Refeicao refeicao, int posicao) {
    rascunho!.refeicoes.insert(posicao, refeicao);
    notifyListeners();
  }

  // [VÍDEO] RF006 · REGRA: refeições do mesmo cardápio não podem se sobrepor no horário.
  // Ordena por horário e compara cada refeição com a seguinte.
  List<String> sobreposicoes(Cardapio c) {
    final lista = List<Refeicao>.from(c.refeicoes);
    lista.sort((a, b) => a.inicio.compareTo(b.inicio));

    final conflitos = <String>[];
    for (var i = 0; i < lista.length - 1; i++) {
      final atual = lista[i];
      final proxima = lista[i + 1];
      if (proxima.inicio < atual.fim) {
        conflitos.add('${atual.nome} e ${proxima.nome}');
      }
    }
    return conflitos;
  }

  // Cada dia da semana tem um cardápio só. Aqui ficam os dias marcados
  // que hoje são de outro cardápio (e vão passar para este ao salvar).
  Map<int, Cardapio> diasTomados(Cardapio c) {
    final tomados = <int, Cardapio>{};
    for (final dia in c.dias) {
      final outro = doDia(dia);
      if (outro != null && outro.id != c.id) {
        tomados[dia] = outro;
      }
    }
    return tomados;
  }

  // Salva o rascunho e tira os dias dele dos outros cardápios.
  // Retorna o nome dos cardápios que perderam algum dia.
  List<String> salvar(Cardapio cardapio) {
    final afetados = <String>[];
    for (final outro in cardapios) {
      if (outro.id == cardapio.id) continue;

      final antes = outro.dias.length;
      outro.dias.removeAll(cardapio.dias);
      if (outro.dias.length != antes) afetados.add(outro.nome);
    }

    final i = cardapios.indexWhere((c) => c.id == cardapio.id);
    if (i == -1) {
      cardapios.add(cardapio);
    } else {
      cardapios[i] = cardapio;
    }
    rascunho = null;
    notifyListeners();
    return afetados;
  }

  int remover(Cardapio cardapio) {
    final i = cardapios.indexWhere((c) => c.id == cardapio.id);
    cardapios.removeAt(i);
    notifyListeners();
    return i;
  }

  void restaurar(Cardapio cardapio, int posicao) {
    cardapios.insert(posicao, cardapio);
    notifyListeners();
  }

  //
  // CARDÁPIOS INICIAIS (dados estáticos da Parte 1)
  // Os números são os ids dos alimentos em data/alimentos_taco.dart.
  //
  ItemRefeicao item(int alimentoId, double gramas) {
    return ItemRefeicao(alimento: alimento(alimentoId), gramas: gramas);
  }

  Refeicao refeicao(String nome, int inicio, int fim, List<ItemRefeicao> itens) {
    return Refeicao(id: novoId('refeicao'), nome: nome, inicio: inicio, fim: fim, itens: itens);
  }

  Cardapio cardapioSegunda() => Cardapio(
        id: 'segunda',
        nome: 'Segunda (treino A)',
        dias: {1},
        refeicoes: [
          refeicao('Café da manhã', 6 * 60 + 30, 6 * 60 + 50, [
            item(53, 50), // pão francês
            item(488, 100), // ovo cozido
            item(471, 150), // café
            item(182, 90), // banana prata
          ]),
          refeicao('Almoço', 12 * 60, 13 * 60, [
            item(3, 150), // arroz tipo 1 cozido
            item(561, 140), // feijão carioca cozido
            item(410, 150), // peito de frango grelhado
            item(100, 80), // brócolis cozido
            item(260, 8), // azeite extra virgem
          ]),
          refeicao('Pré-treino', 17 * 60, 17 * 60 + 15, [
            item(7, 30), // aveia
            item(182, 90), // banana prata
            item(507, 15), // mel
          ]),
          refeicao('Jantar', 22 * 60 + 40, 23 * 60 + 10, [
            item(88, 200), // batata-doce cozida
            item(377, 120), // patinho grelhado
            item(78, 40), // alface
            item(157, 80), // tomate
          ]),
        ],
      );

  Cardapio cardapioTercaASexta() => Cardapio(
        id: 'terca-sexta',
        nome: 'Terça a sexta',
        dias: {2, 3, 4, 5},
        refeicoes: [
          refeicao('Café da manhã', 6 * 60 + 30, 6 * 60 + 50, [
            item(52, 50), // pão de forma integral
            item(461, 30), // queijo minas frescal
            item(448, 170), // iogurte natural
            item(222, 130), // maçã fuji
          ]),
          refeicao('Almoço', 12 * 60, 13 * 60, [
            item(3, 120), // arroz tipo 1 cozido
            item(561, 100), // feijão carioca cozido
            item(317, 120), // salmão grelhado
            item(109, 80), // cenoura cozida
          ]),
          refeicao('Lanche', 17 * 60, 17 * 60 + 15, [
            item(533, 150), // cuscuz de milho
            item(488, 50), // ovo cozido
          ]),
          refeicao('Jantar', 22 * 60 + 40, 23 * 60 + 10, [
            item(129, 150), // mandioca cozida
            item(410, 120), // peito de frango grelhado
            item(163, 60), // abacate
          ]),
        ],
      );
}
