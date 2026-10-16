import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../service/usuario_service.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import 'crona_logo.dart';

//
// [VÍDEO] NAVEGAÇÃO · MENU LATERAL: usuário logado + Perfil (RF005), Exercícios,
// Tabela de alimentos, Sobre (RF004) e Sair.
//
class CronaDrawer extends StatelessWidget {
  const CronaDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarios = GetIt.I<UsuarioService>();

    return Drawer(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: usuarios,
          builder: (context, _) {
            final usuario = usuarios.logado;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // CABEÇALHO
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CronaMarca(tamanho: 44),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: CronaColors.lilac,
                            child: Text(
                              usuario?.inicial ?? '?',
                              style: CronaTheme.display(size: 20, color: CronaColors.night),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usuario?.nome ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  usuario?.email ?? '',
                                  style: const TextStyle(color: CronaColors.steel, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // ITENS
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'perfil');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: const Text('Exercícios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'exercicios');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.manage_search),
                  title: const Text('Tabela de alimentos'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'alimentos');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Sobre'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'sobre');
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: CronaColors.steel),
                  title: const Text('Sair', style: TextStyle(color: CronaColors.steel)),
                  onTap: () {
                    usuarios.sair();
                    Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
                  },
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}

//
// BOTÃO DE AVATAR NA APPBAR (abre o menu lateral)
//
class AvatarMenu extends StatelessWidget {
  const AvatarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarios = GetIt.I<UsuarioService>();
    return ListenableBuilder(
      listenable: usuarios,
      builder: (context, _) => IconButton(
        tooltip: 'Menu',
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: CircleAvatar(
          radius: 16,
          backgroundColor: CronaColors.lilac,
          child: Text(
            usuarios.logado?.inicial ?? '?',
            style: CronaTheme.display(size: 14, color: CronaColors.night),
          ),
        ),
      ),
    );
  }
}
