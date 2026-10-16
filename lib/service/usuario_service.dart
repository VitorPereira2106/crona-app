import 'package:flutter/material.dart';

import '../model/usuario.dart';

//
// ESTADO COMPARTILHADO DA CONTA
// Na Parte 1 os usuários ficam em memória (sem backend).
//
class UsuarioService extends ChangeNotifier {
  final List<Usuario> _usuarios = [
    // CONTA DE DEMONSTRAÇÃO
    Usuario(
      nome: 'Crona',
      email: 'demo@crona.app',
      telefone: '(16) 99999-0000',
      senha: 'crona123',
    ),
  ];

  Usuario? _logado;

  Usuario? get logado => _logado;

  bool get autenticado => _logado != null;

  Usuario? buscarPorEmail(String email) {
    final procurado = email.trim().toLowerCase();
    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() == procurado) return usuario;
    }
    return null;
  }

  bool autenticar(String email, String senha) {
    final usuario = buscarPorEmail(email);
    if (usuario == null || usuario.senha != senha) return false;
    _logado = usuario;
    notifyListeners();
    return true;
  }

  void cadastrar(Usuario usuario) {
    _usuarios.add(usuario);
    _logado = usuario;
    notifyListeners();
  }

  void atualizarPerfil({required String nome}) {
    final usuario = _logado;
    if (usuario == null) return;
    usuario.nome = nome.trim();
    notifyListeners();
  }

  void sair() {
    _logado = null;
    notifyListeners();
  }
}
