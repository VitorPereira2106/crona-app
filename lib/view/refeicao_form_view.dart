import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/nutricao_controller.dart';
import '../model/refeicao.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/dialogo_quantidade.dart';
import '../widgets/grafico_macros.dart';
import '../widgets/sangue_negro.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 8 · MONTAR REFEIÇÃO
// Alimentos da TACO com gramas, horário e o gráfico composto atualizando ao vivo.
// Edita a refeição dentro do cardápio em montagem (rascunho do NutricaoController).
//
class RefeicaoFormView extends StatefulWidget {
  const RefeicaoFormView({super.key, this.refeicaoId});

  final String? refeicaoId; // edição

  @override
  State<RefeicaoFormView> createState() => _RefeicaoFormViewState();
}

class _RefeicaoFormViewState extends State<RefeicaoFormView> {
  static const sugestoes = ['Café da manhã', 'Lanche da manhã', 'Almoço', 'Lanche', 'Pré-treino', 'Jantar', 'Ceia'];

  final ctrl = GetIt.I<NutricaoController>();
  final formKey = GlobalKey<FormState>();
  final txtNome = TextEditingController();

  late Refeicao refeicao;
  bool editando = false;
  bool tentouSalvar = false;

  @override
  void initState() {
    super.initState();
    // Procura a refeição no cardápio que está sendo montado.
    Refeicao? existente;
    for (final r in ctrl.rascunho!.refeicoes) {
      if (r.id == widget.refeicaoId) existente = r;
    }

    // Edita uma cópia: o cardápio só muda ao tocar em "Salvar refeição".
    if (existente != null) {
      editando = true;
      refeicao = existente.copia();
    } else {
      editando = false;
      refeicao = ctrl.novaRefeicao();
    }
    txtNome.text = refeicao.nome;
  }

  @override
  void dispose() {
    txtNome.dispose();
    super.dispose();
  }

  bool get horarioValido => refeicao.fim - refeicao.inicio >= 5;

  Future<void> escolherHorario({required bool inicio}) async {
    final atual = inicio ? refeicao.inicio : refeicao.fim;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: atual ~/ 60, minute: atual % 60),
      helpText: inicio ? 'Começa às' : 'Termina às',
    );
    if (hora == null) return;
    setState(() {
      final minutos = hora.hour * 60 + hora.minute;
      if (inicio) {
        final duracao = refeicao.fim - refeicao.inicio;
        refeicao.inicio = minutos;
        refeicao.fim = (minutos + (duracao > 0 ? duracao : 30)).clamp(0, 24 * 60);
      } else {
        refeicao.fim = minutos;
      }
    });
  }

  Future<void> adicionarAlimento() async {
    final item = await Navigator.pushNamed(context, 'alimentos', arguments: true);
    if (item is ItemRefeicao) setState(() => refeicao.itens.add(item));
  }

  Future<void> editarItem(ItemRefeicao item) async {
    final gramas = await pedirQuantidade(context, item.alimento, inicial: item.gramas, confirmar: 'Atualizar');
    if (gramas != null) setState(() => item.gramas = gramas);
  }

  void salvar() {
    setState(() => tentouSalvar = true);
    final formOk = formKey.currentState!.validate();
    if (!formOk || !horarioValido || refeicao.itens.isEmpty) return;

    refeicao.nome = txtNome.text.trim();
    ctrl.salvarRefeicao(refeicao);
    Navigator.pop(context);
  }

  void excluir() {
    final original = ctrl.rascunho!.refeicoes.firstWhere((r) => r.id == refeicao.id);
    final posicao = ctrl.removerRefeicao(original);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${original.nome} saiu do cardápio.'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => ctrl.restaurarRefeicao(original, posicao),
          ),
        ),
      );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final macros = refeicao.macros;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar refeição' : 'Nova refeição'),
        actions: [
          if (editando)
            IconButton(tooltip: 'Excluir', icon: const Icon(Icons.delete_outline), onPressed: excluir),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            // INPUT NOME
            TextFormField(
              controller: txtNome,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Refeição', hintText: 'Ex.: Almoço'),
              validator: (v) => (v == null || v.trim().length < 2) ? 'Dê um nome à refeição.' : null,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final s in sugestoes)
                  ActionChip(
                    label: Text(s),
                    onPressed: () => setState(() => txtNome.text = s),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // HORÁRIO
            titulo('Horário'),
            Row(
              children: [
                Expanded(child: campoHora('Começa', refeicao.inicio, Icons.schedule, true)),
                const SizedBox(width: 10),
                Expanded(child: campoHora('Termina', refeicao.fim, Icons.timer_outlined, false)),
              ],
            ),
            if (!horarioValido) erro('O fim precisa ser pelo menos 5 minutos depois do início.'),
            const SizedBox(height: 20),

            // RESUMO COM GRÁFICO COMPOSTO
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
                        const Flexible(child: Text('kcal nesta refeição', style: TextStyle(color: CronaColors.steel))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GraficoMacros(macros: macros),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ALIMENTOS
            titulo('Alimentos (${refeicao.itens.length})'),
            for (final item in refeicao.itens) itemAlimento(item),
            if (tentouSalvar && refeicao.itens.isEmpty) erro('Adicione pelo menos um alimento.'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: adicionarAlimento,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar alimento da TACO'),
            ),
            const SizedBox(height: 28),

            // BOTÃO SALVAR
            FilledButton(onPressed: salvar, child: const Text('Salvar refeição')),
          ],
        ),
      ),
    );
  }

  Widget itemAlimento(ItemRefeicao item) {
    final m = item.macros;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 14, right: 4),
        title: Text(item.alimento.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${Formatos.gramas(item.gramas)} · ${Formatos.kcal(m.kcal)}',
          style: CronaTheme.mono(size: 12, color: CronaColors.steel),
        ),
        onTap: () => editarItem(item),
        trailing: IconButton(
          tooltip: 'Remover',
          icon: const Icon(Icons.remove_circle_outline, color: CronaColors.steel),
          onPressed: () => setState(() => refeicao.itens.remove(item)),
        ),
      ),
    );
  }

  Widget campoHora(String rotulo, int minutos, IconData icone, bool inicio) {
    return Card(
      child: ListTile(
        leading: Icon(icone),
        title: Text(rotulo, style: const TextStyle(fontSize: 12, color: CronaColors.steel)),
        subtitle: Text(Formatos.hora(minutos), style: CronaTheme.mono(size: 18)),
        onTap: () => escolherHorario(inicio: inicio),
      ),
    );
  }

  Widget titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(texto, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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
