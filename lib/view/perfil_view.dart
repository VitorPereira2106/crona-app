import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/perfil_controller.dart';
import '../theme/crona_colors.dart';
import '../theme/crona_theme.dart';
import '../util/validadores.dart';

//
// RF005 · PERFIL DO USUÁRIO
// Nome editável; e-mail somente leitura. Só acessível autenticado (guarda em main.dart).
//
class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final ctrl = GetIt.I<PerfilController>();
  final formKey = GlobalKey<FormState>();
  final txtNome = TextEditingController();

  @override
  void initState() {
    super.initState();
    restaurar();
  }

  void restaurar() {
    txtNome.text = ctrl.usuario?.nome ?? '';
  }

  void salvar() {
    if (!formKey.currentState!.validate()) return;

    final erro = ctrl.salvar(txtNome.text);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(erro ?? 'Perfil atualizado.')),
      );
  }

  void cancelar() {
    // reset() limpa os erros (e o texto); por isso restaura depois.
    formKey.currentState!.reset();
    restaurar();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Alterações descartadas.')));
  }

  @override
  void dispose() {
    txtNome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ctrl.usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: formKey,
            child: ListenableBuilder(
              listenable: ctrl,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // AVATAR
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: CronaColors.lilac,
                      child: Text(
                        usuario?.inicial ?? '?',
                        style: CronaTheme.display(size: 34, color: CronaColors.night),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  //
                  // DADOS DO USUÁRIO
                  //

                  // INPUT NOME (editável)
                  TextFormField(
                    controller: txtNome,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: Validadores.nome,
                  ),
                  const SizedBox(height: 16),

                  // EMAIL (somente leitura)
                  TextFormField(
                    initialValue: usuario?.email,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'E-mail (não pode ser alterado)',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TELEFONE (somente leitura)
                  TextFormField(
                    initialValue: usuario?.telefone,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 32),

                  //
                  // BOTÕES EDIÇÃO
                  //
                  FilledButton(onPressed: salvar, child: const Text('Salvar')),
                  const SizedBox(height: 8),
                  TextButton(onPressed: cancelar, child: const Text('Cancelar alterações')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
