import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

import 'view/cadastro_usuario_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';

void main() {
  runApp(DevicePreview(builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crona',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121016),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF4A6C0),
          onPrimary: Color(0xFF121016),
          secondary: Color(0xFFC9BE82),
          tertiary: Color(0xFF78AEBB),
          error: Color(0xFFB8384D),
          surface: Color(0xFF1E1A24),
          onSurface: Color(0xFFEDE7F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1A24),
          foregroundColor: Color(0xFFF4A6C0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4A6C0),
            foregroundColor: const Color(0xFF121016),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(
              0xFFB8A9C9,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4A4254)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF4A6C0)),
          ),
          labelStyle: TextStyle(color: Color(0xFFB8A9C9)),
        ),
      ),
      //
      // ROTAS
      //
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'perfil': (context) => const PerfilView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'sobre': (context) => const SobreView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      },
    );
  }
}
