import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'crona_colors.dart';

//
// TEMA CRONA
// Display: Bricolage Grotesque · Texto: Inter · Horários/percentuais: JetBrains Mono
//
class CronaTheme {
  static const raio = 14.0;

  // Desligado nos testes (sem rede para baixar as fontes).
  static bool usarGoogleFonts = true;

  static TextStyle _fonte(String familia, TextStyle estilo) {
    if (!usarGoogleFonts) return estilo;
    return GoogleFonts.getFont(familia, textStyle: estilo);
  }

  static TextStyle display({
    double size = 28,
    Color color = CronaColors.collar,
  }) {
    return _fonte(
      'Bricolage Grotesque',
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: color,
      ),
    );
  }

  static TextStyle mono({
    double size = 13,
    Color color = CronaColors.lilac,
    FontWeight weight = FontWeight.w500,
  }) {
    return _fonte(
      'JetBrains Mono',
      TextStyle(fontSize: size, fontWeight: weight, color: color),
    );
  }

  static TextStyle _botao() {
    return _fonte('Inter', const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
  }

  static ThemeData get escuro {
    const scheme = ColorScheme.dark(
      primary: CronaColors.lilac,
      onPrimary: CronaColors.night,
      secondary: CronaColors.mauve,
      onSecondary: CronaColors.night,
      tertiary: CronaColors.soul,
      onTertiary: CronaColors.night,
      error: CronaColors.blackBlood,
      onError: CronaColors.collar,
      surface: CronaColors.night,
      onSurface: CronaColors.collar,
      onSurfaceVariant: CronaColors.steel,
      surfaceContainerLow: CronaColors.robe,
      surfaceContainer: CronaColors.robe,
      surfaceContainerHigh: CronaColors.robeRaised,
      surfaceContainerHighest: CronaColors.robeRaised,
      outline: CronaColors.robeRaised,
      outlineVariant: CronaColors.robeRaised,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
    );

    final texto = (usarGoogleFonts ? GoogleFonts.getTextTheme('Inter', base.textTheme) : base.textTheme).apply(
      bodyColor: CronaColors.collar,
      displayColor: CronaColors.collar,
    );

    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(raio),
      borderSide: const BorderSide(color: CronaColors.robeRaised),
    );

    return base.copyWith(
      scaffoldBackgroundColor: CronaColors.night,
      textTheme: texto.copyWith(
        headlineLarge: display(size: 32),
        headlineMedium: display(size: 26),
        headlineSmall: display(size: 22),
        titleLarge: display(size: 20),
      ),

      // APPBAR
      appBarTheme: AppBarTheme(
        backgroundColor: CronaColors.night,
        foregroundColor: CronaColors.collar,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: display(size: 22),
      ),

      // CARDS
      cardTheme: CardThemeData(
        color: CronaColors.robe,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(raio),
        ),
      ),

      // CAMPOS DE INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CronaColors.robe,
        border: borda,
        enabledBorder: borda,
        disabledBorder: borda.copyWith(
          borderSide: const BorderSide(color: CronaColors.robe),
        ),
        focusedBorder: borda.copyWith(
          borderSide: const BorderSide(color: CronaColors.lilac, width: 1.5),
        ),
        errorBorder: borda.copyWith(
          borderSide: const BorderSide(color: CronaColors.blackBlood, width: 2),
        ),
        focusedErrorBorder: borda.copyWith(
          borderSide: const BorderSide(color: CronaColors.blackBlood, width: 2.5),
        ),
        labelStyle: const TextStyle(color: CronaColors.steel),
        floatingLabelStyle: const TextStyle(color: CronaColors.lilac),
        prefixIconColor: CronaColors.steel,
        suffixIconColor: CronaColors.steel,
        // Erro: borda em sangue negro; texto claro para continuar legível.
        errorStyle: const TextStyle(color: CronaColors.collar, fontWeight: FontWeight.w600),
        errorMaxLines: 2,
      ),

      // BOTÕES
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: CronaColors.mauve,
          foregroundColor: CronaColors.night,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raio),
          ),
          textStyle: _botao(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CronaColors.lilac,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: CronaColors.lilac, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raio),
          ),
          textStyle: _botao(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: CronaColors.lilac),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CronaColors.mauve,
        foregroundColor: CronaColors.night,
      ),

      // NAVEGAÇÃO
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: CronaColors.robe,
        indicatorColor: CronaColors.robeRaised,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? CronaColors.lilac
                : CronaColors.steel,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? CronaColors.lilac
                : CronaColors.steel,
          ),
        ),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: CronaColors.night),

      // OUTROS
      chipTheme: ChipThemeData(
        backgroundColor: CronaColors.robe,
        selectedColor: CronaColors.robeRaised,
        checkmarkColor: CronaColors.lilac,
        labelStyle: const TextStyle(color: CronaColors.lilac, fontSize: 13),
        side: const BorderSide(color: CronaColors.robeRaised),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: CronaColors.robeRaised,
        contentTextStyle: TextStyle(color: CronaColors.collar),
        actionTextColor: CronaColors.lilac,
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: CronaColors.robe,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(raio + 4),
        ),
        titleTextStyle: display(size: 20),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: CronaColors.robe,
        showDragHandle: true,
      ),
      dividerTheme: const DividerThemeData(color: CronaColors.robeRaised),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CronaColors.mauve,
        linearTrackColor: CronaColors.robeRaised,
      ),
      listTileTheme: const ListTileThemeData(iconColor: CronaColors.lilac),
    );
  }
}
