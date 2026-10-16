//
// VALIDAÇÕES DE FORMULÁRIO
// Retornam a mensagem de erro, ou null quando o valor é válido.
// [VÍDEO] RF001/RF002/RF003/RF005 · todas as telas usam estas regras: obrigatório,
// formato do e-mail (regex abaixo), senha forte, senha = confirmação e nome mínimo.
//
class Validadores {
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  static String? obrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }
    return null;
  }

  static String? email(String? valor) {
    final vazio = obrigatorio(valor, 'o e-mail');
    if (vazio != null) return vazio;
    if (!_email.hasMatch(valor!.trim())) {
      return 'E-mail em formato inválido (ex.: nome@dominio.com).';
    }
    return null;
  }

  // Login só exige a senha preenchida.
  static String? senhaLogin(String? valor) => obrigatorio(valor, 'a senha');

  // Cadastro: mínimo 8 caracteres, com letra e número.
  static String? senhaNova(String? valor) {
    final vazio = obrigatorio(valor, 'a senha');
    if (vazio != null) return vazio;
    if (valor!.length < 8) return 'A senha precisa ter pelo menos 8 caracteres.';
    if (!RegExp(r'[A-Za-z]').hasMatch(valor) ||
        !RegExp(r'\d').hasMatch(valor)) {
      return 'Use pelo menos uma letra e um número.';
    }
    return null;
  }

  static String? confirmacaoSenha(String? valor, String senha) {
    final vazio = obrigatorio(valor, 'a confirmação da senha');
    if (vazio != null) return vazio;
    if (valor != senha) return 'As senhas não são iguais.';
    return null;
  }

  static String? telefone(String? valor) {
    final vazio = obrigatorio(valor, 'o telefone');
    if (vazio != null) return vazio;
    final digitos = valor!.replaceAll(RegExp(r'\D'), '');
    if (digitos.length < 10 || digitos.length > 11) {
      return 'Telefone com DDD, ex.: (16) 99999-0000.';
    }
    return null;
  }

  static const nomeMinimo = 3;

  static String? nome(String? valor) {
    final vazio = obrigatorio(valor, 'o nome');
    if (vazio != null) return vazio;
    if (valor!.trim().length < nomeMinimo) {
      return 'O nome precisa ter pelo menos $nomeMinimo caracteres.';
    }
    return null;
  }
}
