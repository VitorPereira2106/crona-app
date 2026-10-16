import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/sobre_controller.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../widgets/crona_logo.dart';

//
// RF004 · SOBRE
//
class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  final ctrl = GetIt.I<SobreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const Center(child: CronaMarca(tamanho: 64)),
            const SizedBox(height: 28),

            // OBJETIVO
            secao('Objetivo'),
            Text(ctrl.objetivo, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 24),

            // EQUIPE
            secao('Equipe de desenvolvimento'),
            for (final nome in ctrl.integrantes)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: CronaColors.robeRaised,
                    child: Text(
                      nome[0],
                      style: CronaTheme.display(size: 16, color: CronaColors.lilac),
                    ),
                  ),
                  title: Text(nome),
                ),
              ),
            const SizedBox(height: 16),

            // INFORMAÇÕES ACADÊMICAS
            secao('Projeto'),
            Card(
              child: Column(
                children: [
                  info(Icons.menu_book_outlined, 'Disciplina', ctrl.disciplina),
                  info(Icons.account_balance_outlined, 'Instituição', ctrl.instituicao),
                  info(Icons.school_outlined, 'Professor', ctrl.professor),
                  info(Icons.tag, 'Versão', ctrl.versao),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Estética inspirada em Soul Eater (© Atsushi Ohkubo / Square Enix). '
              'Projeto acadêmico sem fins comerciais.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CronaColors.steel, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget secao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          color: CronaColors.steel,
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget info(IconData icone, String rotulo, String valor) {
    return ListTile(
      leading: Icon(icone),
      title: Text(rotulo, style: const TextStyle(color: CronaColors.steel, fontSize: 13)),
      subtitle: Text(valor, style: const TextStyle(color: CronaColors.collar, fontSize: 15)),
    );
  }
}
