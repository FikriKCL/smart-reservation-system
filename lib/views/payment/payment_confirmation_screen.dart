import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '/widgets/primary_button.dart';
import '../screens/onboarding_screen.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
        parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top card
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2ECC71), Color(0xFF1E8449)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -10,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Balance',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                ),
                                Text(
                                  '\$1299.15',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEB001B),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(-10, 0),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF79E1B)
                                          .withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Confirmation box
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Green circles animation
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer decorative dots
                            ...List.generate(6, (i) {
                              final angle = (i / 6) * 3.14159 * 2;
                              final r = 52.0;
                              return Positioned(
                                left: 60 + r * 0.85 * _cos(angle) - 6,
                                top: 60 + r * 0.85 * _sin(angle) - 6,
                                child: Container(
                                  width: i % 2 == 0 ? 10 : 7,
                                  height: i % 2 == 0 ? 10 : 7,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen
                                        .withOpacity(0.3 + i * 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                            // Center circle
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen
                                        .withOpacity(0.35),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_box_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Congratulations !',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Reservation completed\nsuccessfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.greyText,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: 'Go to Homepage',
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const OnboardingScreen()),
                          (_) => false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _cos(double angle) => angle < 1.57
      ? 1 - angle * angle / 2
      : angle < 3.14
          ? -(angle - 1.57) * (angle - 1.57) / 2 + 0.0
          : _cosImpl(angle);

  double _cosImpl(double a) {
    // Simple approximation
    return (a - 3.14159) < 1.57 ? -(1 - (a - 3.14159) * (a - 3.14159) / 2) : 0;
  }

  double _sin(double angle) {
    return _cos(angle - 1.5708); // sin(x) = cos(x - pi/2)
  }
}