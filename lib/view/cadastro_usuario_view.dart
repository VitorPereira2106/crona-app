import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/cadastro_usuario_controller.dart';
import '../theme/crona_colors.dart';
import '../util/validadores.dart';

//
// RF002 · CADASTRO DE USUÁRIO
//
class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final ctrl = GetIt.I<CadastroUsuarioController>();
  final formKey = GlobalKey<FormState>();
  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();
  final txtTelefone = TextEditingController();
  final txtSenha = TextEditingController();
  final txtConfirmacao = TextEditingController();

  void cadastrar() {
    if (!formKey.currentState!.validate()) return;

    final erro = ctrl.cadastrar(
      nome: txtNome.text,
      email: txtEmail.text,
      telefone: txtTelefone.text,
      senha: txtSenha.text,
      confirmacao: txtConfirmacao.text,
    );
    if (erro != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conta criada. Bem-vindo(a), ${txtNome.text.trim()}!')),
    );
    Navigator.pushNamedAndRemoveUntil(context, 'principal', (_) => false);
  }

  @override
  void dispose() {
    for (final c in [txtNome, txtEmail, txtTelefone, txtSenha, txtConfirmacao]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: formKey,
                child: ListenableBuilder(
                  listenable: ctrl,
                  builder: (context, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Leva só um minuto. Depois a gente lida com o resto juntos.',
                        style: TextStyle(color: CronaColors.steel),
                      ),
                      const SizedBox(height: 24),

                      //
                      // CAMPOS DE INPUT
                      //

                      // INPUT NOME
                      TextFormField(
                        controller: txtNome,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: Validadores.nome,
                      ),
                      const SizedBox(height: 16),

                      // INPUT EMAIL
                      TextFormField(
                        controller: txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: Validadores.email,
                      ),
                      const SizedBox(height: 16),

                      // INPUT TELEFONE
                      TextFormField(
                        controller: txtTelefone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          hintText: '(16) 99999-0000',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: Validadores.telefone,
                      ),
                      const SizedBox(height: 16),

                      // INPUT SENHA
                      TextFormField(
                        controller: txtSenha,
                        obscureText: !ctrl.senhaVisivel,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          helperText: 'Mínimo 8 caracteres, com letra e número.',
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
                        validator: Validadores.senhaNova,
                      ),
                      const SizedBox(height: 16),

                      // INPUT CONFIRMAÇÃO DE SENHA
                      TextFormField(
                        controller: txtConfirmacao,
                        obscureText: !ctrl.senhaVisivel,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => cadastrar(),
                        decoration: const InputDecoration(
                          labelText: 'Confirme sua senha',
                          prefixIcon: Icon(Icons.lock_reset_outlined),
                        ),
                        validator: (v) => Validadores.confirmacaoSenha(v, txtSenha.text),
                      ),
                      const SizedBox(height: 32),

                      // BOTÃO CADASTRAR
                      FilledButton(
                        onPressed: cadastrar,
                        child: const Text('Cadastrar'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Já tenho conta'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
