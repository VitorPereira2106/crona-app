import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/treino_controller.dart';
import '../model/treino.dart';
import '../service/usuario_service.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/crona_drawer.dart';
import '../widgets/estado_vazio.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 1 · ROTINA DE TREINOS (RF007: ListView)
// Lista os treinos da semana; criar, editar e excluir (com "Desfazer").
//
class TreinosView extends StatefulWidget {
  const TreinosView({super.key});

  @override
  State<TreinosView> createState() => _TreinosViewState();
}

class _TreinosViewState extends State<TreinosView> {
  final ctrl = GetIt.I<TreinoController>();
  final usuarios = GetIt.I<UsuarioService>();

  void excluir(Treino treino) {
    final posicao = ctrl.remover(treino);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${treino.nome} excluído.'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => ctrl.restaurar(treino, posicao),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CronaDrawer(),
      appBar: AppBar(
        leading: const AvatarMenu(),
        // [VÍDEO] RF005 · o nome salvo no Perfil aparece aqui (ListenableBuilder no UsuarioService).
        title: ListenableBuilder(
          listenable: usuarios,
          builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oi, ${usuarios.logado?.primeiroNome ?? ''}.',
                style: const TextStyle(fontSize: 13, color: CronaColors.steel),
              ),
              const Text('Treinos'),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Biblioteca de exercícios',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => Navigator.pushNamed(context, 'exercicios'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null, // várias abas com FAB no mesmo IndexedStack
        onPressed: () => Navigator.pushNamed(context, 'treino_form'),
        icon: const Icon(Icons.add),
        label: const Text('Novo treino'),
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          if (ctrl.treinos.isEmpty) {
            return Center(
              child: EstadoVazio(
                mensagem: 'Nenhum treino ainda. Eu também não sei por onde começar... mas vamos juntos?',
                acao: 'Criar treino',
                onAcao: () => Navigator.pushNamed(context, 'treino_form'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
            itemCount: ctrl.treinos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => cardTreino(ctrl.treinos[i]),
          );
        },
      ),
    );
  }

  Widget cardTreino(Treino treino) {
    final foco = ctrl.foco(treino);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'treino_detalhe', arguments: treino.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(treino.nome, style: CronaTheme.display(size: 19)),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Opções',
                    onSelected: (opcao) {
                      if (opcao == 'editar') {
                        Navigator.pushNamed(context, 'treino_form', arguments: treino.id);
                      } else {
                        excluir(treino);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                    ],
                  ),
                ],
              ),
              Text(
                '${Formatos.dias(treino.dias)}  ·  ${Formatos.intervalo(treino.inicio, treino.fim)}',
                style: CronaTheme.mono(size: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  etiqueta('${treino.itens.length} exercícios'),
                  for (final m in foco) etiqueta(m.nome, destaque: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget etiqueta(String texto, {bool destaque = false}) {
    final cor = destaque ? CronaColors.mauve : CronaColors.lilac;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(texto, style: TextStyle(fontSize: 11, color: cor, fontWeight: FontWeight.w600)),
    );
  }
}
