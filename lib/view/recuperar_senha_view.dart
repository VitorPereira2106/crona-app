import 'package:flutter/material.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.key,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Recuperar senha',
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
              Text(
                'Insira o seu e-mail no campo abaixo para recuperar sua senha.',
              ),

              SizedBox(
                height: 24,
              ),

              // INPUT EMAIL
              TextField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
              ),

              SizedBox(
                height: 24,
              ),

              // BOTÃO RECUPERAR
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {},
                child: const Text(
                  'Enviar link',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
