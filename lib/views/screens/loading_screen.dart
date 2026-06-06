import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'splash_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _spinnerCtrl;
  late AnimationController _exitCtrl;

  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _spinnerOpacity;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );

    _spinnerCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _spinnerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _spinnerCtrl, curve: Curves.easeIn),
    );

    _exitCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _spinnerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    await _exitCtrl.forward();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SplashScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _spinnerCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _exitOpacity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AnimatedBuilder(
                animation: _logoCtrl,
                builder: (_, child) => Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                ),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2.5),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'H',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                      height: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
              FadeTransition(
                opacity: _spinnerOpacity,
                child: const _SpinningDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpinningDots extends StatefulWidget {
  const _SpinningDots();

  @override
  State<_SpinningDots> createState() => _SpinningDotsState();
}

class _SpinningDotsState extends State<_SpinningDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _DotsPainter(_ctrl.value),
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  final double progress;
  _DotsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 19.0;
    const dotCount = 8;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi - math.pi / 2;
      final pos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final t = (progress - i / dotCount) % 1.0;
      final opacity = (1.0 - t).clamp(0.12, 1.0);
      final dotR = (3.0 * opacity + 0.8).clamp(0.8, 4.5);

      canvas.drawCircle(
        pos,
        dotR,
        Paint()
          ..color = Colors.green.withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => old.progress != progress;
}