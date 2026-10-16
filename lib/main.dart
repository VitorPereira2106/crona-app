import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'controller/cadastro_usuario_controller.dart';
import 'controller/exercicio_controller.dart';
import 'controller/login_controller.dart';
import 'controller/nutricao_controller.dart';
import 'controller/perfil_controller.dart';
import 'controller/recuperar_senha_controller.dart';
import 'controller/sobre_controller.dart';
import 'controller/treino_controller.dart';
import 'service/usuario_service.dart';
import 'theme/crona_theme.dart';
import 'view/alimentos_view.dart';
import 'view/cadastro_usuario_view.dart';
import 'view/cardapio_form_view.dart';
import 'view/exercicio_detalhe_view.dart';
import 'view/exercicios_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/principal_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/refeicao_form_view.dart';
import 'view/sobre_view.dart';
import 'view/treino_detalhe_view.dart';
import 'view/treino_form_view.dart';

//
// [VÍDEO] GERENCIAMENTO DE ESTADO · INJEÇÃO DE DEPENDÊNCIAS
// Cada controller é um ChangeNotifier registrado uma única vez no get_it.
// As telas pegam o controller com GetIt.I<...>() e se redesenham com ListenableBuilder
// sempre que ele chama notifyListeners().
//
void configurarDependencias() {
  final g = GetIt.I;
  g.registerLazySingleton(() => UsuarioService());
  g.registerLazySingleton(() => ExercicioController());
  g.registerLazySingleton(() => TreinoController());
  g.registerLazySingleton(() => NutricaoController());
  g.registerLazySingleton(() => LoginController());
  g.registerLazySingleton(() => CadastroUsuarioController());
  g.registerLazySingleton(() => RecuperarSenhaController());
  g.registerLazySingleton(() => PerfilController());
  g.registerLazySingleton(() => SobreController());
}

void main() {
  configurarDependencias();
  runApp(DevicePreview(builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // [VÍDEO] RF005 · REGRA "SÓ USUÁRIO AUTENTICADO ACESSA O PERFIL"
  // Rotas protegidas: sem login, onGenerateRoute manda de volta para o login.
  static const rotasProtegidas = {
    'principal',
    'perfil',
    'treino_form',
    'treino_detalhe',
    'exercicios',
    'exercicio_detalhe',
    'cardapio_form',
    'refeicao_form',
    'alimentos',
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crona',
      theme: CronaTheme.escuro,
      builder: DevicePreview.appBuilder,

      // PORTUGUÊS (seletor de horário, textos do Material)
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      //
      // [VÍDEO] NAVEGAÇÃO · ROTAS NOMEADAS
      // As telas navegam com Navigator.pushNamed(context, 'nome', arguments: id).
      //
      initialRoute: 'login',
      onGenerateRoute: (settings) {
        // Sem login, as rotas protegidas voltam para o login.
        var nome = settings.name;
        final autenticado = GetIt.I<UsuarioService>().autenticado;
        if (rotasProtegidas.contains(nome) && !autenticado) {
          nome = 'login';
        }

        // Argumento: id (texto) do item a editar, ou true para abrir a tabela de
        // alimentos no modo "selecionar".
        final arg = settings.arguments;
        String? id;
        if (arg is String) id = arg;

        Widget tela;
        switch (nome) {
          case 'cadastro_usuario':
            tela = const CadastroUsuarioView();
          case 'recuperar_senha':
            tela = const RecuperarSenhaView();
          case 'sobre':
            tela = const SobreView();
          case 'principal':
            tela = const PrincipalView();
          case 'perfil':
            tela = const PerfilView();
          case 'treino_form':
            tela = TreinoFormView(treinoId: id);
          case 'treino_detalhe':
            tela = TreinoDetalheView(treinoId: id!);
          case 'exercicios':
            tela = const ExerciciosView();
          case 'exercicio_detalhe':
            tela = ExercicioDetalheView(exercicioId: id!);
          case 'cardapio_form':
            tela = CardapioFormView(cardapioId: id);
          case 'refeicao_form':
            tela = RefeicaoFormView(refeicaoId: id);
          case 'alimentos':
            tela = AlimentosView(selecionar: arg == true);
          default:
            tela = const LoginView();
        }

        return MaterialPageRoute(builder: (_) => tela, settings: settings);
      },
    );
  }
}
