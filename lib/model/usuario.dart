class Usuario {
  Usuario({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  String nome;
  final String email;
  final String telefone;
  final String senha;

  String get primeiroNome => nome.trim().split(' ').first;

  String get inicial => nome.trim().isEmpty ? '?' : nome.trim()[0].toUpperCase();
}
