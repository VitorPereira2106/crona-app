import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../service/usuario_service.dart';
import '../util/validadores.dart';

class LoginController extends ChangeNotifier {
  final _usuarios = GetIt.I<UsuarioService>();

  bool senhaVisivel = false;

  void alternarSenha() {
    senhaVisivel = !senhaVisivel;
    notifyListeners();
  }

  // [VÍDEO] RF001 · LOGIN: verifica se e-mail e senha foram preenchidos, valida o formato do
  // e-mail e autentica. Retorna a mensagem de erro, ou null quando o login deu certo.
  String? entrar(String email, String senha) {
    final erro = Validadores.email(email) ?? Validadores.senhaLogin(senha);
    if (erro != null) return erro;

    if (!_usuarios.autenticar(email, senha)) {
      return 'E-mail ou senha incorretos.';
    }
    senhaVisivel = false;
    return null;
  }
}
