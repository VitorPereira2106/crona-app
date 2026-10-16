import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/nutricao_controller.dart';
import '../model/refeicao.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/grafico_macros.dart';
import '../widgets/refeicao_card.dart';
import '../widgets/sangue_negro.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 9 · MONTAR O DIA (CARDÁPIO)
// Junta as refeições do dia num grupo ("Segunda", "Terça a sexta") e escolhe os dias da semana.
//
class CardapioFormView extends StatefulWidget {
  const CardapioFormView({super.key, this.cardapioId});

  final String? cardapioId; // edição

  @override
  State<CardapioFormView> createState() => _CardapioFormViewState();
}

class _CardapioFormViewState extends State<CardapioFormView> {
  final ctrl = GetIt.I<NutricaoController>();
  final formKey = GlobalKey<FormState>();
  final txtNome = TextEditingController();

  late final Cardapio cardapio;
  bool editando = false;
  bool tentouSalvar = false;

  @override
  void initState() {
    super.initState();
    // Edita um rascunho (cópia): nada muda até tocar em "Salvar cardápio".
    editando = ctrl.iniciarRascunho(id: widget.cardapioId);
    cardapio = ctrl.rascunho!;
    txtNome.text = cardapio.nome;
  }

  @override
  void dispose() {
    txtNome.dispose();
    super.dispose();
  }

  // [VÍDEO] RF006 · VALIDAÇÃO DO CARDÁPIO
  // Precisa de nome, de pelo menos uma refeição e de refeições sem horário sobreposto.
  void salvar() {
    setState(() => tentouSalvar = true);
    final formOk = formKey.currentState!.validate();
    if (!formOk || cardapio.refeicoes.isEmpty || ctrl.sobreposicoes(cardapio).isNotEmpty) return;

    cardapio.nome = txtNome.text.trim();

    final afetados = ctrl.salvar(cardapio);
    final mensagem = cardapio.dias.isEmpty
        ? 'Cardápio guardado. Marque um dia da semana para usá-lo.'
        : 'Cardápio salvo.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          afetados.isEmpty ? mensagem : '$mensagem Os dias saíram de ${Formatos.lista(afetados)}.',
        ),
      ),
    );
    Navigator.pop(context);
  }

  void excluir() {
    final original = ctrl.buscar(cardapio.id);
    if (original == null) return;
    final posicao = ctrl.remover(original);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${original.nome} excluído.'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => ctrl.restaurar(original, posicao),
          ),
        ),
      );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar cardápio' : 'Novo cardápio'),
        actions: [
          if (editando)
            IconButton(tooltip: 'Excluir', icon: const Icon(Icons.delete_outline), onPressed: excluir),
        ],
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          final macros = cardapio.macros;
          final tomados = ctrl.diasTomados(cardapio);
          final sobrepostas = ctrl.sobreposicoes(cardapio);
          final doDia = cardapio.percentualPorRefeicao();

          return Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: [
                // INPUT NOME
                TextFormField(
                  controller: txtNome,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nome do cardápio',
                    hintText: 'Ex.: Segunda, Dia de treino',
                  ),
                  validator: (v) => (v == null || v.trim().length < 2) ? 'Dê um nome ao cardápio.' : null,
                ),
                const SizedBox(height: 20),

                // DIAS DA SEMANA
                titulo('Vale para'),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var d = 1; d <= 7; d++)
                      FilterChip(
                        label: Text(Formatos.diaCurto(d)),
                        selected: cardapio.dias.contains(d),
                        onSelected: (marcado) => setState(() {
                          marcado ? cardapio.dias.add(d) : cardapio.dias.remove(d);
                        }),
                      ),
                  ],
                ),
                for (final dia in tomados.keys)
                  aviso('${Formatos.diaCurto(dia)} hoje é de "${tomados[dia]!.nome}" e passa para este cardápio.'),
                const SizedBox(height: 20),

                // RESUMO DO DIA
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              macros.kcal.round().toString(),
                              style: CronaTheme.mono(size: 30, weight: FontWeight.w700, color: CronaColors.collar),
                            ),
                            const SizedBox(width: 6),
                            const Flexible(child: Text('kcal no dia', style: TextStyle(color: CronaColors.steel))),
                          ],
                        ),
                        const SizedBox(height: 14),
                        GraficoMacros(macros: macros),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // REFEIÇÕES
                titulo('Refeições (${cardapio.refeicoes.length})'),
                for (var i = 0; i < cardapio.refeicoes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RefeicaoCard(
                      refeicao: cardapio.refeicoes[i],
                      percentualDoDia: doDia[i],
                      onTap: () => Navigator.pushNamed(context, 'refeicao_form', arguments: cardapio.refeicoes[i].id),
                    ),
                  ),
                for (final par in sobrepostas) erro('$par estão no mesmo horário.'),
                if (tentouSalvar && cardapio.refeicoes.isEmpty) erro('Monte pelo menos uma refeição.'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, 'refeicao_form'),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar refeição'),
                ),
                const SizedBox(height: 28),

                // BOTÃO SALVAR
                FilledButton(onPressed: salvar, child: const Text('Salvar cardápio')),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(texto, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }

  Widget aviso(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz, size: 14, color: CronaColors.moon),
          const SizedBox(width: 6),
          Expanded(child: Text(texto, style: const TextStyle(fontSize: 12, color: CronaColors.steel))),
        ],
      ),
    );
  }

  Widget erro(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          const GotaSangueNegro(tamanho: 12),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(color: CronaColors.collar, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
