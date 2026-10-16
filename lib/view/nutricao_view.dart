import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/nutricao_controller.dart';
import '../model/refeicao.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/formatos.dart';
import '../widgets/crona_drawer.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/grafico_macros.dart';
import '../widgets/linha_ativacao.dart';

//
// [VÍDEO] RF006 · FUNCIONALIDADE 6 · NUTRIÇÃO (cardápios salvos)
// Cada cardápio é um dia cheio de refeições, com o gráfico composto de macros (ListView).
//
class NutricaoView extends StatefulWidget {
  const NutricaoView({super.key});

  @override
  State<NutricaoView> createState() => _NutricaoViewState();
}

class _NutricaoViewState extends State<NutricaoView> {
  final ctrl = GetIt.I<NutricaoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CronaDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null, // várias abas com FAB no mesmo IndexedStack
        onPressed: () => Navigator.pushNamed(context, 'cardapio_form'),
        icon: const Icon(Icons.add),
        label: const Text('Cardápio'),
      ),
      appBar: AppBar(
        leading: const AvatarMenu(),
        title: const Text('Nutrição'),
        actions: [
          IconButton(
            tooltip: 'Tabela de alimentos (TACO)',
            icon: const Icon(Icons.manage_search),
            onPressed: () => Navigator.pushNamed(context, 'alimentos'),
          ),
        ],
      ),
      // [VÍDEO] GERENCIAMENTO DE ESTADO · a lista se redesenha quando o NutricaoController notifica.
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          final cardapios = ctrl.cardapios;
          if (cardapios.isEmpty) {
            return Center(
              child: EstadoVazio(
                mensagem: 'Nenhum cardápio ainda. Quer montar o seu dia, refeição por refeição?',
                acao: 'Montar cardápio',
                onAcao: () => Navigator.pushNamed(context, 'cardapio_form'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
            itemCount: cardapios.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _CardapioCard(
              cardapio: cardapios[i],
              onTap: () => Navigator.pushNamed(context, 'cardapio_form', arguments: cardapios[i].id),
            ),
          );
        },
      ),
    );
  }
}

//
// CARD DO CARDÁPIO: kcal do dia, gráfico composto e o peso de cada refeição no dia.
//
class _CardapioCard extends StatelessWidget {
  const _CardapioCard({required this.cardapio, required this.onTap});

  final Cardapio cardapio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final macros = cardapio.macros;
    final doDia = cardapio.percentualPorRefeicao();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CABEÇALHO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cardapio.nome, style: CronaTheme.display(size: 20)),
                        const SizedBox(height: 2),
                        Text(
                          cardapio.dias.isEmpty ? 'Sem dia da semana' : Formatos.dias(cardapio.dias),
                          style: CronaTheme.mono(size: 12, color: CronaColors.steel),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        macros.kcal.round().toString(),
                        style: CronaTheme.mono(size: 22, weight: FontWeight.w700, color: CronaColors.collar),
                      ),
                      const Text('kcal no dia', style: TextStyle(fontSize: 11, color: CronaColors.steel)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // GRÁFICO COMPOSTO DO DIA
              GraficoMacros(macros: macros, compacto: true),
              const SizedBox(height: 16),

              // PESO DE CADA REFEIÇÃO NAS CALORIAS DO DIA
              const Text(
                '% DO DIA',
                style: TextStyle(color: CronaColors.steel, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < cardapio.refeicoes.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        child: Text(Formatos.hora(cardapio.refeicoes[i].inicio), style: CronaTheme.mono(size: 11, color: CronaColors.steel)),
                      ),
                      Expanded(child: LinhaAtivacao(rotulo: cardapio.refeicoes[i].nome, percentual: doDia[i], compacta: true)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
