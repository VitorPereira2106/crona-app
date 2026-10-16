import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/recuperar_senha_controller.dart';
import '../theme/crona_colors.dart';
import '../util/validadores.dart';

//
// RF003 · ESQUECEU A SENHA
//
class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final ctrl = GetIt.I<RecuperarSenhaController>();
  final formKey = GlobalKey<FormState>();
  final txtEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrl.reiniciar();
  }

  void recuperar() {
    if (!formKey.currentState!.validate()) return;

    final erro = ctrl.recuperar(txtEmail.text);
    if (erro != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro)));
    }
  }

  @override
  void dispose() {
    txtEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: ctrl,
                builder: (context, _) =>
                    ctrl.emailEnviado == null ? formulario() : confirmacao(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formulario() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset, size: 56, color: CronaColors.lilac),
          const SizedBox(height: 16),
          const Text(
            'Esqueceu? Acontece. Informe o e-mail da sua conta e enviaremos as instruções para criar uma nova senha.',
            style: TextStyle(color: CronaColors.steel, height: 1.4),
          ),
          const SizedBox(height: 24),

          // INPUT EMAIL
          TextFormField(
            controller: txtEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            onFieldSubmitted: (_) => recuperar(),
            decoration: const InputDecoration(
              labelText: 'E-mail cadastrado',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            validator: Validadores.email,
          ),
          const SizedBox(height: 32),

          // BOTÃO RECUPERAR
          FilledButton(
            onPressed: recuperar,
            child: const Text('Enviar instruções'),
          ),
        ],
      ),
    );
  }

  Widget confirmacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 56, color: CronaColors.soul),
        const SizedBox(height: 16),
        Text(
          'Instruções enviadas!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Enviamos as instruções de redefinição para ${ctrl.emailEnviado}. '
          'Confira também a caixa de spam.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: CronaColors.steel, height: 1.4),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Voltar ao login'),
        ),
      ],
    );
  }
}
