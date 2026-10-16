import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../service/usuario_service.dart';
import '../util/validadores.dart';

class RecuperarSenhaController extends ChangeNotifier {
  final _usuarios = GetIt.I<UsuarioService>();

  // E-mail para onde as instruções foram "enviadas" (simulado na Parte 1).
  String? emailEnviado;

  // [VÍDEO] RF003 · ESQUECEU A SENHA: valida o e-mail, confere se a conta existe e "envia"
  // as instruções. Retorna a mensagem de erro, ou null quando as instruções foram enviadas.
  String? recuperar(String email) {
    final erro = Validadores.email(email);
    if (erro != null) return erro;

    if (_usuarios.buscarPorEmail(email) == null) {
      return 'Não encontrei uma conta com esse e-mail.';
    }

    emailEnviado = email.trim();
    notifyListeners();
    return null;
  }

  void reiniciar() {
    emailEnviado = null;
    notifyListeners();
  }
}
