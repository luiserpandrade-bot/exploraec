import 'package:flutter/material.dart';
import 'package:exploraec/bienvenida_claude_design.dart';

void main() {
  runApp(const ExploraEcApp());
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      home: const BienvenidaScreen(),
    );
  }
}

// Paleta y escala tipográfica del design system "Andean Canopy" (Stitch).
class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  static const Color _fondo = Color(0xFFF8FAFC);
  static const Color _primario = Color(0xFF0D9488);
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
                        color: _primario.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.explore_outlined,
                        size: 44,
                        color: _primario,
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
                    const Text(
                      'Descubre lugares increíbles cerca de ti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 26 / 16,
                        color: _textoSecundario,
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primario,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      elevation: 2,
                      shadowColor: _primario.withValues(alpha: 0.4),
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
