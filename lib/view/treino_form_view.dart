import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/exercicio_controller.dart';
import '../controller/treino_controller.dart';
import '../model/exercicio.dart';
import '../model/treino.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/dialogo_conflito.dart';
import '../widgets/sangue_negro.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 2 · CADASTRAR / EDITAR TREINO
// Nome, dias, horário e exercícios; conflitos com outros treinos são verificados ao salvar.
//
class TreinoFormView extends StatefulWidget {
  const TreinoFormView({super.key, this.treinoId});

  final String? treinoId;

  @override
  State<TreinoFormView> createState() => _TreinoFormViewState();
}

class _TreinoFormViewState extends State<TreinoFormView> {
  final treinos = GetIt.I<TreinoController>();
  final exercicios = GetIt.I<ExercicioController>();
  final formKey = GlobalKey<FormState>();
  final txtNome = TextEditingController();

  late Treino treino;
  bool editando = false;
  bool tentouSalvar = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.treinoId == null ? null : treinos.buscar(widget.treinoId!);
    editando = existente != null;
    // Edita uma cópia: nada muda até tocar em "Salvar".
    treino = existente?.copia() ?? treinos.novo();
    txtNome.text = treino.nome;
  }

  @override
  void dispose() {
    txtNome.dispose();
    super.dispose();
  }

  Future<void> escolherHorario() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: treino.inicio ~/ 60, minute: treino.inicio % 60),
      helpText: 'Horário de início',
    );
    if (hora != null) setState(() => treino.inicio = hora.hour * 60 + hora.minute);
  }

  Future<void> adicionarExercicio() async {
    final escolhido = await showModalBottomSheet<Exercicio>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _SeletorExercicio(),
    );
    if (escolhido != null) {
      setState(() => treino.itens.add(ItemTreino(exercicioId: escolhido.id)));
    }
  }

  Future<void> editarItem(ItemTreino item) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _EditorPrescricao(
        item: item,
        nome: exercicios.porId(item.exercicioId).nome,
      ),
    );
    setState(() {});
  }

  Future<void> salvar() async {
    setState(() => tentouSalvar = true);
    final formOk = formKey.currentState!.validate();
    if (!formOk || treino.dias.isEmpty || treino.itens.isEmpty) return;

    treino.nome = txtNome.text.trim();

    // [VÍDEO] RF006 · VALIDAÇÃO + VERIFICAÇÃO DE CONFLITO antes de salvar
    final conflitos = treinos.conflitos(treino);
    if (conflitos.isNotEmpty) {
      final manter = await showDialog<bool>(
        context: context,
        builder: (_) => DialogoConflito(conflitos: conflitos),
      );
      if (manter != true) return;
    }

    treinos.salvar(treino);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(editando ? 'Treino atualizado.' : 'Treino criado.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sugerida = Treino.duracaoSugerida(treino.itens);

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar treino' : 'Novo treino')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            // INPUT NOME
            TextFormField(
              controller: txtNome,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome do treino',
                hintText: 'Ex.: Treino D · Upper',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (v) => (v == null || v.trim().length < 2) ? 'Dê um nome ao treino.' : null,
            ),
            const SizedBox(height: 24),

            // DIAS DA SEMANA
            titulo('Dias da semana'),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(Formatos.diaCurto(d)),
                    selected: treino.dias.contains(d),
                    onSelected: (marcado) => setState(() {
                      marcado ? treino.dias.add(d) : treino.dias.remove(d);
                    }),
                  ),
              ],
            ),
            if (tentouSalvar && treino.dias.isEmpty) erro('Escolha pelo menos um dia.'),
            const SizedBox(height: 24),

            // HORÁRIO E DURAÇÃO
            titulo('Horário'),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('Início', style: TextStyle(fontSize: 12, color: CronaColors.steel)),
                      subtitle: Text(Formatos.hora(treino.inicio), style: CronaTheme.mono(size: 18)),
                      onTap: escolherHorario,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.timer_outlined),
                      title: const Text('Fim', style: TextStyle(fontSize: 12, color: CronaColors.steel)),
                      subtitle: Text(Formatos.hora(treino.fim), style: CronaTheme.mono(size: 18)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Duração: ${treino.duracao} min', style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                if (treino.itens.isNotEmpty && sugerida != treino.duracao)
                  TextButton(
                    onPressed: () => setState(() => treino.duracao = sugerida),
                    child: Text('Usar sugerida ($sugerida min)'),
                  ),
              ],
            ),
            Slider(
              value: treino.duracao.toDouble(),
              min: 15,
              max: 180,
              divisions: 33,
              label: '${treino.duracao} min',
              activeColor: CronaColors.mauve,
              inactiveColor: CronaColors.robeRaised,
              onChanged: (v) => setState(() => treino.duracao = v.round()),
            ),
            const SizedBox(height: 16),

            // EXERCÍCIOS
            Row(
              children: [
                Expanded(child: titulo('Exercícios (${treino.itens.length})')),
                TextButton.icon(
                  onPressed: adicionarExercicio,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            if (treino.itens.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: CronaColors.robeRaised),
                  borderRadius: BorderRadius.circular(CronaTheme.raio),
                ),
                child: const Text(
                  'Nenhum exercício ainda. Toque em "Adicionar" para montar o treino.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CronaColors.steel),
                ),
              ),
            if (tentouSalvar && treino.itens.isEmpty) erro('Adicione pelo menos um exercício.'),
            for (var i = 0; i < treino.itens.length; i++) itemExercicio(i),
            const SizedBox(height: 28),

            // BOTÃO SALVAR
            FilledButton(onPressed: salvar, child: const Text('Salvar treino')),
          ],
        ),
      ),
    );
  }

  Widget itemExercicio(int i) {
    final item = treino.itens[i];
    final exercicio = exercicios.porId(item.exercicioId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: CronaColors.robeRaised,
            child: Text('${i + 1}', style: CronaTheme.mono(size: 12)),
          ),
          title: Text(exercicio.nome),
          subtitle: Text(
            '${item.series} × ${item.repeticoes} · ${item.descanso}s',
            style: CronaTheme.mono(size: 12, color: CronaColors.steel),
          ),
          onTap: () => editarItem(item),
          trailing: IconButton(
            tooltip: 'Remover',
            icon: const Icon(Icons.close, color: CronaColors.steel),
            onPressed: () => setState(() => treino.itens.removeAt(i)),
          ),
        ),
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

//
// EDITOR DE PRESCRIÇÃO: séries, repetições e descanso
//
class _EditorPrescricao extends StatefulWidget {
  const _EditorPrescricao({required this.item, required this.nome});

  final ItemTreino item;
  final String nome;

  @override
  State<_EditorPrescricao> createState() => _EditorPrescricaoState();
}

class _EditorPrescricaoState extends State<_EditorPrescricao> {
  late int series = widget.item.series;
  late int descanso = widget.item.descanso;
  late final txtReps = TextEditingController(text: widget.item.repeticoes);

  @override
  void dispose() {
    txtReps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.nome),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Séries')),
              IconButton(
                onPressed: series > 1 ? () => setState(() => series--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$series', style: CronaTheme.mono(size: 18)),
              IconButton(
                onPressed: series < 10 ? () => setState(() => series++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: txtReps,
            decoration: const InputDecoration(
              labelText: 'Repetições',
              hintText: '10, 8–12 ou 30 s',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: descanso,
            decoration: const InputDecoration(labelText: 'Descanso'),
            items: [
              for (final s in const [30, 45, 60, 75, 90, 120, 180])
                DropdownMenuItem(value: s, child: Text('$s s')),
            ],
            onChanged: (v) => setState(() => descanso = v ?? descanso),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () {
            widget.item
              ..series = series
              ..descanso = descanso
              ..repeticoes = txtReps.text.trim().isEmpty ? widget.item.repeticoes : txtReps.text.trim();
            Navigator.pop(context);
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}

//
// SELETOR DE EXERCÍCIO (bottom sheet com busca)
//
class _SeletorExercicio extends StatefulWidget {
  const _SeletorExercicio();

  @override
  State<_SeletorExercicio> createState() => _SeletorExercicioState();
}

class _SeletorExercicioState extends State<_SeletorExercicio> {
  final exercicios = GetIt.I<ExercicioController>();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    final termo = busca.toLowerCase();
    final lista = exercicios.todos
        .where((e) => e.nome.toLowerCase().contains(termo) || e.primario.nome.toLowerCase().contains(termo))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: false,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome ou músculo',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => busca = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final e = lista[i];
                return ListTile(
                  title: Text(e.nome),
                  subtitle: Text(
                    '${e.primario.nome} · ${e.equipamento}',
                    style: const TextStyle(color: CronaColors.steel),
                  ),
                  trailing: const Icon(Icons.add),
                  onTap: () => Navigator.pop(context, e),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
