import 'package:flutter/material.dart';

/// Pantalla de bienvenida según el artboard "Bienvenida" del canvas de diseño.
/// Paleta y escala tipográfica del design system "Andean Canopy".
class BienvenidaScreenClaudeDesign extends StatelessWidget {
  const BienvenidaScreenClaudeDesign({
    super.key,
    this.accent = _accentPorDefecto,
    this.onEmpezar,
  });

  /// Color de acento del botón y del ícono, equivalente al tweak "accent"
  /// del artboard. Verde teal 700: 5.47:1 de contraste sobre texto blanco.
  final Color accent;

  /// Acción del botón 'Empezar'. Sin navegación por ahora.
  final VoidCallback? onEmpezar;

  static const Color _accentPorDefecto = Color(0xFF0F766E);
  static const Color _fondo = Color(0xFFF8FAFC);
  static const Color _textoPrincipal = Color(0xFF0F172A);
  static const Color _textoSecundario = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.explore_outlined,
                        size: 42,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'ExploraEC',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 40 / 32,
                        letterSpacing: -0.8,
                        color: _textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: const Text(
                        'Descubre lugares increíbles cerca de ti',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 26 / 16,
                          color: _textoSecundario,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onEmpezar ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      elevation: 6,
                      shadowColor: accent.withValues(alpha: 0.35),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.16,
                      ),
                    ),
                    child: const Text('Empezar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
