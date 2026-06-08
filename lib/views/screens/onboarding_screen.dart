import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../screens/payment_methods_screen.dart';
import '/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600',
      title: "Let's have the best vacation with us",
      subtitle:
          'Discover the world\'s most beautiful destinations and book your perfect getaway with ease.',
    ),
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600',
      title: 'Travel made easy in your hands',
      subtitle:
          'Browse thousands of hotels, compare prices, and secure your booking in just a few taps.',
    ),
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
      title: "Let's have the best vacation with us",
      subtitle:
          'Enjoy exclusive deals, 24/7 support, and a seamless travel experience from start to finish.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPayment();
    }
  }

  void _skip() => _navigateToPayment();

  void _navigateToPayment() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PadelApp(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
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
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
          ),
          // Bottom nav
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    final isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.primaryGreen
                            : const Color(0xFFD0D0D0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _skip,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
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

class OnboardingData {
  final String imageUrl;
  final String title;
  final String subtitle;

  const OnboardingData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Diagonal-clipped image
        ClipPath(
          clipper: _DiagonalClipper(),
          child: SizedBox(
            height: size.height * 0.52,
            width: double.infinity,
            child: Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppTheme.lightGreen,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Welcome badge
        Padding(
          padding: const EdgeInsets.only(left: 28, top: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Welcome to Hotel',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkText,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.greyText,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
