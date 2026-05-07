import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class TelaSplash extends StatefulWidget {
  const TelaSplash({super.key});

  @override
  State<TelaSplash> createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash> with TickerProviderStateMixin {
  late final AnimationController _bikeController;
  late final AnimationController _fadeController;
  late final AnimationController _rodaController;

  late final Animation<double> _bikeSlide;
  late final Animation<double> _bikeFade;
  late final Animation<double> _textoFade;
  late final Animation<Offset> _textoSlide;
  late final Animation<double> _subtituloFade;

  @override
  void initState() {
    super.initState();

    // Controller da bike (entrada)
    _bikeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Controller do fade geral (saída)
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Controller da roda girando
    _rodaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Bike desliza da esquerda para o centro
    _bikeSlide = Tween<double>(begin: -120.0, end: 0.0).animate(
      CurvedAnimation(parent: _bikeController, curve: Curves.easeOutCubic),
    );

    // Bike aparece
    _bikeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bikeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Texto "SpinFlow" aparece e sobe
    _textoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bikeController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textoSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _bikeController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Subtítulo aparece por último
    _subtituloFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bikeController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _iniciarAnimacoes();
  }

  Future<void> _iniciarAnimacoes() async {
    // Roda começa a girar
    _rodaController.repeat();

    // Pequeno delay inicial
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Bike entra
    await _bikeController.forward();
    if (!mounted) return;

    // Roda para de girar suavemente
    _rodaController.stop();

    // Espera um pouco na tela
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Fade out
    await _fadeController.forward();
    if (!mounted) return;

    // Navega para login
    Navigator.pushReplacementNamed(context, Rotas.login);
  }

  @override
  void dispose() {
    _bikeController.dispose();
    _fadeController.dispose();
    _rodaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tema.primaryColor,
                tema.primaryColor.withValues(alpha: 0.8),
                Colors.deepPurple.shade900,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bike animada
                AnimatedBuilder(
                  animation: Listenable.merge([_bikeController, _rodaController]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_bikeSlide.value, 0),
                      child: Opacity(
                        opacity: _bikeFade.value,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Sombra
                              Positioned(
                                bottom: 8,
                                child: Container(
                                  width: 60,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Container branco com bike
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Transform.rotate(
                                  angle: _rodaController.value * 2 * pi,
                                  child: Icon(
                                    Icons.pedal_bike_rounded,
                                    size: 50,
                                    color: tema.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Texto "SpinFlow"
                SlideTransition(
                  position: _textoSlide,
                  child: FadeTransition(
                    opacity: _textoFade,
                    child: const Text(
                      'SpinFlow',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Subtítulo
                FadeTransition(
                  opacity: _subtituloFade,
                  child: Text(
                    'Pedale no ritmo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loading indicator
                FadeTransition(
                  opacity: _subtituloFade,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
