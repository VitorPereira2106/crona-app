import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/login_controller.dart';
import '../theme/crona_colors.dart';
import '../util/validadores.dart';
import '../widgets/crona_logo.dart';

//
// RF001 · LOGIN
//
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ctrl = GetIt.I<LoginController>();
  final formKey = GlobalKey<FormState>();
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();

  void entrar() {
    if (!formKey.currentState!.validate()) return;

    final erro = ctrl.entrar(txtEmail.text, txtSenha.text);
    if (erro != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro)));
      return;
    }
    Navigator.pushReplacementNamed(context, 'principal');
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    // LOGOTIPO
                    // [VÍDEO] RF001 · tela de login: logo, e-mail, senha, Entrar, Cadastro e Esqueceu a senha.
                    //
                    const Center(child: CronaMarca(tamanho: 76)),
                    const SizedBox(height: 12),
                    const Text(
                      'Seu cronograma, sem conflitos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CronaColors.steel),
                    ),
                    const SizedBox(height: 40),

                    //
                    // CAMPOS DE INPUT
                    //

                    // INPUT EMAIL
                    TextFormField(
                      controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: Validadores.email,
                    ),
                    const SizedBox(height: 16),

                    // INPUT SENHA
                    ListenableBuilder(
                      listenable: ctrl,
                      builder: (context, _) => TextFormField(
                        controller: txtSenha,
                        obscureText: !ctrl.senhaVisivel,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => entrar(),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: ctrl.senhaVisivel ? 'Ocultar senha' : 'Mostrar senha',
                            onPressed: ctrl.alternarSenha,
                            icon: Icon(
                              ctrl.senhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: Validadores.senhaLogin,
                      ),
                    ),

                    // BOTÃO ESQUECEU SENHA
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, 'recuperar_senha'),
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    //
                    // BOTÕES
                    //

                    // BOTÃO ENTRAR
                    FilledButton(
                      onPressed: entrar,
                      child: const Text('Entrar'),
                    ),
                    const SizedBox(height: 12),

                    // BOTÃO CADASTRAR
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, 'cadastro_usuario'),
                      child: const Text('Criar conta'),
                    ),
                    const SizedBox(height: 24),

                    // CONTA DE DEMONSTRAÇÃO
                    const Text(
                      'Conta de teste: demo@crona.app · crona123',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CronaColors.steel, fontSize: 12),
                    ),

                    // BOTÃO SOBRE
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, 'sobre'),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Sobre'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
