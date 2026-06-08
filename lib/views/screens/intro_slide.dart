import 'package:flutter/material.dart';
import 'login_screen.dart';

// Data per halaman intro
class _PageData {
  final String title;
  final String subtitle;
  final String imagePath;
  const _PageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _PageData(
      title: 'Temukan Lapangan\nPadel Terbaik',
      subtitle: 'Cari dan pesan lapangan padel favoritmu dengan mudah dan cepat.',
      imagePath: 'assets/images/01.jpeg',
    ),
    _PageData(
      title: 'Booking Mudah\ndi Genggaman',
      subtitle: 'Pilih jadwal, pilih lapangan, dan booking hanya dalam beberapa tap.',
      imagePath: 'assets/images/02.jpeg',
    ),
    _PageData(
      title: 'Siap Bermain\nBersama Kami',
      subtitle: 'Nikmati pengalaman bermain padel yang menyenangkan bersama teman.',
      imagePath: 'assets/images/03.jpeg',
    ),
  ];

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Konten halaman
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _SliderPage(data: _pages[i]),
            ),
          ),

          // Kontrol bawah
          Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              top: 16,
            ),
            child: Column(
              children: [
                // Dot indikator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Tombol
                Row(
                  children: [
                    // Tombol skip
                    if (_currentPage < _pages.length - 1)
                      Expanded(
                        child: GestureDetector(
                          onTap: _goToLogin,
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Lewati',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage < _pages.length - 1)
                      const SizedBox(width: 12),

                    // Tombol next / mulai
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _next,
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? 'Mulai Sekarang'
                                : 'Lanjut',
                            style: const TextStyle(
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
        ],
      ),
    );
  }
}

class _SliderPage extends StatelessWidget {
  final _PageData data;
  const _SliderPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Gambar
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: Image.asset(
            data.imagePath,
            width: double.infinity,
            height: size.height * 0.5,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: size.height * 0.5,
              color: const Color(0xFFD1FAE5),
              child: const Icon(
                Icons.sports_tennis,
                size: 80,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        ),

        // Teks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
