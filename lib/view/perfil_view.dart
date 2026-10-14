import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Perfil de usuário',
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
              Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(
                    width: 6,
                  ),
                  Text('Dados do usuário'),
                ],
              ),

              SizedBox(
                height: 12,
              ),

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

              SizedBox(
                height: 24,
              ),

              // BOTÕES EDIÇÃO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancelar alterações',
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {},
                    child: const Text(
                      'Salvar',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
