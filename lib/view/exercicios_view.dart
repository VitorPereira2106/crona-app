import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/exercicio_controller.dart';
import '../model/exercicio.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../widgets/estado_vazio.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 4 · BIBLIOTECA DE EXERCÍCIOS (RF007: GridView)
// Busca por nome/equipamento e filtro por músculo. Abre pelo botão da aba Treinos ou pelo menu lateral.
//
class ExerciciosView extends StatefulWidget {
  const ExerciciosView({super.key});

  @override
  State<ExerciciosView> createState() => _ExerciciosViewState();
}

class _ExerciciosViewState extends State<ExerciciosView> {
  final ctrl = GetIt.I<ExercicioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercícios')),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          final lista = ctrl.filtrados;
          return Column(
            children: [
              // BUSCA
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar exercício ou equipamento',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: ctrl.buscar,
                ),
              ),

              // FILTRO POR MÚSCULO
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: const Text('Todos'),
                        selected: ctrl.filtroMusculo == null,
                        onSelected: (_) => ctrl.filtrar(null),
                      ),
                    ),
                    for (final m in ctrl.musculosComExercicio)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(m.nome),
                          selected: ctrl.filtroMusculo == m,
                          onSelected: (_) => ctrl.filtrar(m),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // GRADE
              Expanded(
                child: lista.isEmpty
                    ? const Center(
                        child: EstadoVazio(mensagem: 'Não achei nada com isso... tenta outra palavra?'),
                      )
                    // [VÍDEO] RF007 · GridView com os exercícios (dados estáticos em lib/data).
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisExtent: 150,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: lista.length,
                        itemBuilder: (context, i) => cardExercicio(lista[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget cardExercicio(Exercicio e) {
    final principal = e.musculosOrdenados.first;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'exercicio_detalhe', arguments: e.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.equipamento.toUpperCase(),
                style: const TextStyle(color: CronaColors.steel, fontSize: 10, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  e.nome,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.2),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(principal.key.nome, style: const TextStyle(fontSize: 12, color: CronaColors.lilac)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(value: principal.value / 100, minHeight: 6),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${principal.value}%',
                    style: CronaTheme.mono(size: 11, color: CronaColors.mauve, weight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
