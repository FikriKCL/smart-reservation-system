import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import 'add_new_card_screen.dart';
import 'payment_confirmation_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedMethod = 0; // 0=paypal, 1=google, 2=apple, 3=card

  final List<_PaymentOption> _methods = [
    _PaymentOption(
      label: 'PayPal',
      icon: _PaymentIcons.paypal,
      color: const Color(0xFF003087),
    ),
    _PaymentOption(
      label: 'Google Pay',
      icon: _PaymentIcons.googlePay,
      color: const Color(0xFF4285F4),
    ),
    _PaymentOption(
      label: 'Apple Pay',
      icon: _PaymentIcons.applePay,
      color: Colors.black,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Payment'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view_rounded, color: AppTheme.darkText),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkText,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddNewCardScreen()),
                  ),
                  child: const Text(
                    'Add new card',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Digital wallets
            ...List.generate(_methods.length, (i) {
              final m = _methods[i];
              return _PaymentTile(
                label: m.label,
                icon: m.icon,
                isSelected: _selectedMethod == i,
                onTap: () => setState(() => _selectedMethod = i),
              );
            }),

            const SizedBox(height: 24),

            // Debit/Credit card section
            _SavedCardTile(
              isSelected: _selectedMethod == 3,
              onTap: () => setState(() => _selectedMethod = 3),
            ),

            const Spacer(),

            PrimaryButton(
              label: 'Continue',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PaymentConfirmationScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption {
  final String label;
  final Widget icon;
  final Color color;

  _PaymentOption(
      {required this.label, required this.icon, required this.color});
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightGreen : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 32, height: 32, child: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.darkText,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.greyText,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCardTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _SavedCardTile({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightGreen : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay with Debit/Credit Card',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Mastercard mini icon
                Container(
                  width: 40,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: _MastercardIcon(size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '•••• •••• •••• 4679',
                    style: TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : AppTheme.greyText,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 13)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Icon widgets ────────────────────────────────────────────────────────────

class _PaymentIcons {
  static Widget get paypal => CustomPaint(
        painter: _PaypalPainter(),
      );

  static Widget get googlePay => CustomPaint(
        painter: _GooglePayPainter(),
      );

  static Widget get applePay => const Icon(
        Icons.apple,
        color: Colors.black,
        size: 28,
      );
}

class _PaypalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw simplified "P" in PayPal blue
    paint.color = const Color(0xFF003087);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 2, size.width - 8, size.height - 4),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, paint);

    paint.color = Colors.white;
    final textSpan = TextSpan(
      text: 'P',
      style: TextStyle(
        color: Colors.white,
        fontSize: size.height * 0.65,
        fontWeight: FontWeight.bold,
      ),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2,
            (size.height - tp.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GooglePayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFFEA4335),
      const Color(0xFFFBBC05),
      const Color(0xFF34A853),
    ];
    final segmentWidth = size.width / 4;
    for (int i = 0; i < 4; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(i * segmentWidth, 4, segmentWidth - 1, size.height - 8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MastercardIcon extends StatelessWidget {
  final double size;
  const _MastercardIcon({this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.65,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: size * 0.6,
              height: size * 0.65,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: size * 0.6,
              height: size * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}