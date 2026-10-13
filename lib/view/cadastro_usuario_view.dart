import 'package:flutter/material.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_add,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Cadastro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //
              // CAMPOS DE INPUT
              //

              // INPUT USUÁRIO
              TextField(
                decoration: const InputDecoration(labelText: 'Usuário'),
              ),

              // INPUT EMAIL
              TextField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
              ),

              // INPUT TELEFONE
              TextField(
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),

              // INPUT SENHA
              TextField(
                decoration: const InputDecoration(labelText: 'Senha'),
              ),

              // INPUT CONFIRMAR SENHA
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Confirme sua senha',
                ),
              ),

              //
              // BOTÕES
              //

              // BOTÃO ENTRAR
              SizedBox(
                height: 48,
              ),
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {},
                child: const Text(
                  'Finalizar cadastro',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
