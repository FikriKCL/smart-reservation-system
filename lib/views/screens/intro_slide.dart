import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _shapeCtrl;
  late AnimationController _contentCtrl;
  late Animation<double> _shapeScale;
  late Animation<Offset> _shapeSlide;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  final _pages = const [
    _PageData(
      title: 'Lets have the best,\nvacation with us',
      subtitle:
          'Discover the world\'s most beautiful destinations and book your perfect getaway with ease.',
      imagePath: 'assets/images/01.jpeg',
    ),
    _PageData(
      title: 'Travel made easy in your hands',
      subtitle:
          'Browse thousands of hotels, compare prices, and secure your booking in just a few taps.',
      imagePath: 'assets/images/02.jpeg',
    ),
    _PageData(
      title: 'Lets discover the World\nWith us',
      subtitle:
          'Enjoy exclusive deals, 24/7 support, and a seamless travel experience from start to finish.',
      imagePath: 'assets/images/03.jpeg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _shapeCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shapeScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _shapeCtrl, curve: Curves.easeOut),
    );
    _shapeSlide = Tween<Offset>(
      begin: const Offset(0.15, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _shapeCtrl, curve: Curves.easeOut));

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

    _playEntrance();
  }

  void _playEntrance() async {
    _shapeCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 200));
    _contentCtrl.forward(from: 0);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _contentCtrl.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _skip() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🤔',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lewati Intro?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kamu akan melewati semua panduan intro. Lanjutkan?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green, width: 1.5),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _goToAuth();
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Ya, Skip',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _shapeCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _shapeCtrl.forward(from: 0);
              _contentCtrl.forward(from: 0);
            },
            itemCount: _pages.length,
            itemBuilder: (_, i) => _SliderPage(
              data: _pages[i],
              shapeScale: _shapeScale,
              shapeSlide: _shapeSlide,
              contentOpacity: _contentOpacity,
              contentSlide: _contentSlide,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(
              current: _currentPage,
              total: _pages.length,
              onSkip: _skip,
              onNext: _next,
              isLast: _currentPage == _pages.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _PageData {
  final String title;
  final String subtitle;
  final String imagePath; // ← tambahan
  const _PageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

// ── Slider Page ───────────────────────────────────────────────────────────────

class _SliderPage extends StatelessWidget {
  final _PageData data;
  final Animation<double> shapeScale;
  final Animation<Offset> shapeSlide;
  final Animation<double> contentOpacity;
  final Animation<Offset> contentSlide;

  const _SliderPage({
    required this.data,
    required this.shapeScale,
    required this.shapeSlide,
    required this.contentOpacity,
    required this.contentSlide,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.52;

    return Column(
      children: [
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: SlideTransition(
            position: shapeSlide,
            child: ScaleTransition(
              scale: shapeScale,
              alignment: Alignment.topRight,
              child: ClipPath(
                clipper: _CurvedClipper(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar
                    Image.asset(
                      data.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xFF4CAF50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: FadeTransition(
            opacity: contentOpacity,
            child: SlideTransition(
              position: contentSlide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.9,
      0,
      size.height * 0.55,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_CurvedClipper _) => false;
}

class _BottomBar extends StatelessWidget {
  final int current;
  final int total;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final bool isLast;

  const _BottomBar({
    required this.current,
    required this.total,
    required this.onSkip,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (i) {
              final active = i == current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.green : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _Btn(label: 'Skip', onTap: onSkip, filled: false),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _Btn(
                  label: isLast ? 'Get Started' : 'Next',
                  onTap: onNext,
                  filled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _Btn({required this.label, required this.onTap, required this.filled});

  @override
  State<_Btn> createState() => _BtnState();
}

class _BtnState extends State<_Btn> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.filled ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: widget.filled
                ? null
                : Border.all(color: Colors.green, width: 1.5),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: widget.filled ? Colors.white : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}