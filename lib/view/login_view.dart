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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.punch_clock_rounded,
              size: 32,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Text(
              'Crona',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
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
              Expanded(
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
                            decoration: const InputDecoration(
                              labelText: 'E-Mail',
                            ),
                          ),

                          // INPUT SENHA
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                            ),
                          ),

                          SizedBox(height: 24),

                          // BOTÃO ESQUECEU SENHA
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'recuperar_senha');
                            },
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
                          onPressed: () {
                            Navigator.pushNamed(context, 'perfil');
                          },
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

              // BOTÃO SOBRE (colado no rodapé)
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'sobre');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepPurple),
                    SizedBox(
                      width: 6,
                    ),
                    const Text(
                      'Sobre',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
