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
              color: Colors.black,
            ),
            SizedBox(width: 8),
            Text(
              'Cadastro',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.red.shade50,
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
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Colors.amber,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Finalizar cadastro',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
