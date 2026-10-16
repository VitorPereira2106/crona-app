import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/exercicio_controller.dart';
import '../controller/treino_controller.dart';
import '../model/exercicio.dart';
import '../model/treino.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/linha_ativacao.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 3 · TREINO DO DIA
// Exercícios em cards expansíveis + percentual de ativação de cada músculo no treino.
//
class TreinoDetalheView extends StatefulWidget {
  const TreinoDetalheView({super.key, required this.treinoId});

  final String treinoId;

  @override
  State<TreinoDetalheView> createState() => _TreinoDetalheViewState();
}

class _TreinoDetalheViewState extends State<TreinoDetalheView> {
  final treinos = GetIt.I<TreinoController>();
  final exercicios = GetIt.I<ExercicioController>();

  // Só um card expandido por vez.
  int? aberto = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: treinos,
      builder: (context, _) {
        final treino = treinos.buscar(widget.treinoId);
        if (treino == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: EstadoVazio(mensagem: 'Esse treino não existe mais.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Formatos.dias(treino.dias)} · ${Formatos.intervalo(treino.inicio, treino.fim)}',
                  style: CronaTheme.mono(size: 11, color: CronaColors.steel),
                ),
                Text(treino.nome),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Editar treino',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.pushNamed(context, 'treino_form', arguments: treino.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              for (var i = 0; i < treino.itens.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: cardExercicio(i, treino.itens[i]),
                ),
              const SizedBox(height: 8),
              ativacaoDoTreino(treino),
            ],
          ),
        );
      },
    );
  }

  Widget cardExercicio(int i, ItemTreino item) {
    final exercicio = exercicios.porId(item.exercicioId);
    final expandido = aberto == i;

    return Material(
      color: CronaColors.robe,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CronaTheme.raio),
        side: expandido ? const BorderSide(color: CronaColors.mauve) : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => aberto = expandido ? null : i),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercicio.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          '${item.series} × ${item.repeticoes} · ${item.descanso}s',
                          style: CronaTheme.mono(size: 12, color: CronaColors.steel),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expandido ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more, color: CronaColors.steel),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: expandido ? embasamento(exercicio) : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // [VÍDEO] RF006 · PERCENTUAL DE ATIVAÇÃO DO TREINO
  // Soma a ativação de cada exercício × séries; o músculo mais trabalhado vale 100%.
  //
  Widget ativacaoDoTreino(Treino treino) {
    final ativacao = treinos.ativacao(treino).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Músculos trabalhados', style: CronaTheme.display(size: 18)),
            const SizedBox(height: 12),
            if (ativacao.isEmpty)
              const Text('Sem exercícios.')
            else
              for (final m in ativacao)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LinhaAtivacao(rotulo: m.key.nome, percentual: m.value),
                ),
          ],
        ),
      ),
    );
  }

  //
  // ATIVAÇÃO DO EXERCÍCIO (ao abrir o card)
  //
  Widget embasamento(Exercicio e) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          for (final m in e.musculosOrdenados)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: LinhaAtivacao(rotulo: m.key.nome, percentual: m.value, compacta: true),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, 'exercicio_detalhe', arguments: e.id),
              child: const Text('Ver execução ›'),
            ),
          ),
        ],
      ),
    );
  }
}
