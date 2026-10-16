import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/usuario.dart';
import '../service/usuario_service.dart';
import '../util/validadores.dart';

class PerfilController extends ChangeNotifier {
  final _usuarios = GetIt.I<UsuarioService>();

  Usuario? get usuario => _usuarios.logado;

  // [VÍDEO] RF005 · PERFIL: valida o nome (preenchido e com mínimo de caracteres) e atualiza.
  // O novo nome aparece nas outras telas porque o UsuarioService avisa os ouvintes (notifyListeners).
  String? salvar(String nome) {
    final erro = Validadores.nome(nome);
    if (erro != null) return erro;

    _usuarios.atualizarPerfil(nome: nome);
    return null;
  }

  void sair() => _usuarios.sair();
}
