import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.punch_clock_rounded,
              size: 28,
              color: Colors.black,
            ),
            SizedBox(width: 8),
            Text(
              'Crona',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    //
                    // CAMPOS DE INPUT
                    //

                    // INPUT EMAIL
                    TextField(
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                    ),

                    // INPUT SENHA
                    TextField(
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),

                    SizedBox(height: 24),

                    // BOTÃO ESQUECEU SENHA
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),

                    SizedBox(height: 12),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  // BOTÕES
                  //

                  // BOTÃO ENTRAR
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.amber,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  SizedBox(width: 24),

                  // BOTÃO CADASTRAR
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.amber,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'cadastro_usuario');
                    },
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(color: Colors.black),
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
