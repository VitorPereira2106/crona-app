import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/nutricao_controller.dart';
import '../model/alimento.dart';
import '../model/refeicao.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/dialogo_quantidade.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/grafico_macros.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 7 · TABELA DE ALIMENTOS (TACO)
// Busca e filtro por grupo (ListView). No modo "selecionar", devolve um ItemRefeicao para a refeição.
//
class AlimentosView extends StatefulWidget {
  const AlimentosView({super.key, this.selecionar = false});

  final bool selecionar;

  @override
  State<AlimentosView> createState() => _AlimentosViewState();
}

class _AlimentosViewState extends State<AlimentosView> {
  final ctrl = GetIt.I<NutricaoController>();
  final txtBusca = TextEditingController();
  GrupoAlimento? grupo;

  @override
  void dispose() {
    txtBusca.dispose();
    super.dispose();
  }

  Future<void> tocar(Alimento a) async {
    if (!widget.selecionar) {
      mostrarDetalhe(a);
      return;
    }
    final gramas = await pedirQuantidade(context, a);
    if (gramas == null || !mounted) return;
    Navigator.pop(context, ItemRefeicao(alimento: a, gramas: gramas));
  }

  @override
  Widget build(BuildContext context) {
    final lista = ctrl.buscarAlimentos(txtBusca.text, grupo);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selecionar ? 'Escolher alimento' : 'Tabela de alimentos'),
      ),
      body: Column(
        children: [
          // INPUT BUSCA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: txtBusca,
              autofocus: widget.selecionar,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar: arroz, frango grelhado, banana...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: txtBusca.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(txtBusca.clear),
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // FILTRO POR GRUPO
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                filtro(null, 'Todos'),
                for (final g in GrupoAlimento.values) filtro(g, g.rotulo),
              ],
            ),
          ),

          // CONTAGEM E FONTE
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${lista.length} ALIMENTOS',
                    style: const TextStyle(color: CronaColors.steel, fontSize: 12, letterSpacing: 1.2),
                  ),
                ),
                const Text('por 100 g · TACO', style: TextStyle(color: CronaColors.steel, fontSize: 12)),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: lista.isEmpty
                ? const Center(
                    child: EstadoVazio(mensagem: 'Não achei nada com isso... tenta outra palavra?'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: lista.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) => item(lista[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget filtro(GrupoAlimento? g, String rotulo) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(rotulo),
        selected: grupo == g,
        onSelected: (_) => setState(() => grupo = g),
      ),
    );
  }

  Widget item(Alimento a) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(a.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'P ${Formatos.gramas(a.proteina)} · C ${Formatos.gramas(a.carboidrato)} · G ${Formatos.gramas(a.lipidio)}',
                style: CronaTheme.mono(size: 12, color: CronaColors.steel),
              ),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            a.kcal.round().toString(),
            style: CronaTheme.mono(size: 16, weight: FontWeight.w700, color: CronaColors.collar),
          ),
          const Text('kcal', style: TextStyle(fontSize: 11, color: CronaColors.steel)),
        ],
      ),
      onTap: () => tocar(a),
    );
  }

  //
  // DETALHE (100 g) com o gráfico composto
  //
  void mostrarDetalhe(Alimento a) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                a.grupo.rotulo.toUpperCase(),
                style: const TextStyle(color: CronaColors.steel, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(a.nome, style: CronaTheme.display(size: 20)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    a.kcal.round().toString(),
                    style: CronaTheme.mono(size: 30, weight: FontWeight.w700, color: CronaColors.collar),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(child: Text('kcal em 100 g', style: TextStyle(color: CronaColors.steel))),
                  Text(
                    'fibra ${Formatos.gramas(a.fibra)}',
                    style: CronaTheme.mono(size: 12, color: CronaColors.steel),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GraficoMacros(macros: a.porcao(100)),
            ],
          ),
        ),
      ),
    );
  }
}
