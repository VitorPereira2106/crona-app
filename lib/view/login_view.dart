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
            ),
            SizedBox(width: 4),
            Text(
              'Crona',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
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
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.pushNamed(context, 'perfil');
                          },
                          child: const Text(
                            'Entrar',
                          ),
                        ),

                        SizedBox(width: 24),

                        // BOTÃO CADASTRAR
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.pushNamed(context, 'cadastro_usuario');
                          },
                          child: const Text(
                            'Criar conta',
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
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 6,
                    ),
                    const Text(
                      'Sobre',
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
