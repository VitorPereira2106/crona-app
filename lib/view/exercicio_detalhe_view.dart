import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/exercicio_controller.dart';
import '../theme/crona_colors.dart';
import '../widgets/linha_ativacao.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 5 · DETALHE DO EXERCÍCIO
// Execução + percentual de ativação de cada músculo que ele trabalha.
//
class ExercicioDetalheView extends StatefulWidget {
  const ExercicioDetalheView({super.key, required this.exercicioId});

  final String exercicioId;

  @override
  State<ExercicioDetalheView> createState() => _ExercicioDetalheViewState();
}

class _ExercicioDetalheViewState extends State<ExercicioDetalheView> {
  final exercicios = GetIt.I<ExercicioController>();
  late final exercicio = exercicios.porId(widget.exercicioId);

  @override
  Widget build(BuildContext context) {
    final e = exercicio;

    return Scaffold(
      appBar: AppBar(title: Text(e.nome)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Align(alignment: Alignment.centerLeft, child: Chip(label: Text(e.equipamento))),
          const SizedBox(height: 16),

          // [VÍDEO] RF006 · PERCENTUAL DE ATIVAÇÃO de cada músculo (barras)
          secao('Ativação', Column(
            children: [
              for (final m in e.musculosOrdenados)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LinhaAtivacao(rotulo: m.key.nome, percentual: m.value),
                ),
            ],
          )),
          secao('Execução', Text(e.execucao, style: const TextStyle(height: 1.5))),
        ],
      ),
    );
  }

  Widget secao(String titulo, Widget conteudo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.toUpperCase(),
            style: const TextStyle(color: CronaColors.steel, fontSize: 11, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          conteudo,
        ],
      ),
    );
  }
}
