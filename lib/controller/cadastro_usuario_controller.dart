import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/usuario.dart';
import '../service/usuario_service.dart';
import '../util/validadores.dart';

class CadastroUsuarioController extends ChangeNotifier {
  final _usuarios = GetIt.I<UsuarioService>();

  bool senhaVisivel = false;

  void alternarSenha() {
    senhaVisivel = !senhaVisivel;
    notifyListeners();
  }

  // [VÍDEO] RF002 · CADASTRO: campos obrigatórios, formato do e-mail e senha = confirmação.
  // Retorna a mensagem de erro, ou null quando o cadastro deu certo (e já entra no app).
  String? cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String confirmacao,
  }) {
    final erro = Validadores.nome(nome) ??
        Validadores.email(email) ??
        Validadores.telefone(telefone) ??
        Validadores.senhaNova(senha) ??
        Validadores.confirmacaoSenha(confirmacao, senha);
    if (erro != null) return erro;

    if (_usuarios.buscarPorEmail(email) != null) {
      return 'Já existe uma conta com esse e-mail.';
    }

    _usuarios.cadastrar(
      Usuario(
        nome: nome.trim(),
        email: email.trim(),
        telefone: telefone.trim(),
        senha: senha,
      ),
    );
    senhaVisivel = false;
    return null;
  }
}
